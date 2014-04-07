require 'digest/sha1'
require 'user_activation_job'
require 'securerandom'

# User models the system users, and is generated by the acts_as_authenticated
# Rails generator.
class User < ActiveRecord::Base

  attr_accessible :login, :email, :password, :password_confirmation, :activated_at

  N_('Password')
  N_('Password confirmation')
  N_('Terms accepted')

  SEARCHABLE_FIELDS = {
    :email => {:label => _('Email'), :weight => 5},
  }

  def self.[](login)
    self.find_by_login(login)
  end

  # FIXME ugly workaround
  def self.human_attribute_name_with_customization(attrib, options={})
    case attrib.to_sym
      when :login
        return [_('Username'), _('Email')].join(' / ')
      when :email
        return _('e-Mail')
      else _(self.human_attribute_name_without_customization(attrib))
    end
  end
  class << self
    alias_method_chain :human_attribute_name, :customization
  end

  before_create do |user|
    if user.environment.nil?
      user.environment = Environment.default
    end
    user.send(:make_activation_code) unless user.environment.enabled?('skip_new_user_email_confirmation')
  end

  after_create do |user|
    unless user.person
      p = Person.new

      p.attributes = user.person_data
      p.identifier = user.login
      p.user = user
      p.environment = user.environment
      p.name ||= user.name || user.login
      p.visible = false unless user.activated?
      p.save!

      user.person = p
    end
    if user.environment.enabled?('skip_new_user_email_confirmation')
      if user.environment.enabled?('admin_must_approve_new_users')
        create_moderate_task
      else
        user.activate
      end
    end
  end
  after_create :deliver_activation_code
  after_create :delay_activation_check

  attr_writer :person_data
  def person_data
    @person_data || {}
  end

  def email_domain
    self.person.preferred_domain && self.person.preferred_domain.name || self.environment.default_hostname(true)
  end

  # virtual attribute used to stash which community to join on signup or login
  attr_accessor :community_to_join

  def signup!
    User.transaction do
      self.save!
      self.person.save!
    end
  end

  has_one :person, :dependent => :destroy
  belongs_to :environment

  attr_protected :activated_at

  # Virtual attribute for the unencrypted password
  attr_accessor :password, :name

  validates_presence_of     :login, :email
  validates_format_of       :login, :with => Profile::IDENTIFIER_FORMAT, :if => (lambda {|user| !user.login.blank?})
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 2..40, :if => (lambda {|user| !user.login.blank?})
  validates_length_of       :email,    :within => 3..100, :if => (lambda {|user| !user.email.blank?})
  validates_uniqueness_of   :login, :email, :case_sensitive => false, :scope => :environment_id
  before_save :encrypt_password
  before_save :normalize_email, if: proc{ |u| u.email.present? }
  validates_format_of :email, :with => Noosfero::Constants::EMAIL_FORMAT, :if => (lambda {|user| !user.email.blank?})

  validates_inclusion_of :terms_accepted, :in => [ '1' ], :if => lambda { |u| ! u.terms_of_use.blank? }, :message => N_('{fn} must be checked in order to signup.').fix_i18n

  # Authenticates a user by their login name or email and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password, environment = nil)
    environment ||= Environment.default
    u = self.first :conditions => ['(login = ? OR email = ?) AND environment_id = ? AND activated_at IS NOT NULL',
                                   login, login, environment.id] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def register_login
    self.update_attribute :last_login_at, Time.now
  end

  #FIXME make this test
  def generate_private_token!
    self.private_token = SecureRandom.hex
    self.private_token_generated_at = DateTime.now
    save(false)
  end

  #FIXME make this test
  def private_token_expired?
    self.generate_private_token! if self.private_token.nil? || (self.private_token_generated_at + 2.weeks < DateTime.now)
  end

  # Activates the user in the database.
  def activate
    return false unless self.person
    self.activated_at = Time.now.utc
    self.activation_code = nil
    self.person.visible = true
    begin
      self.person.save! && self.save!
    rescue Exception => exception
      logger.error(exception.to_s)
      false
    else
      if environment.enabled?('send_welcome_email_to_new_users') && environment.has_signup_welcome_text?
        Delayed::Job.enqueue(UserMailer::Job.new(self, :signup_welcome_email))
      end
      true
    end
  end

  # Deactivates the user in the database.
  def deactivate
    return false unless self.person
    self.activated_at = nil
    self.person.visible = false
    begin
      self.person.save! && self.save!
    rescue Exception => exception
      logger.error(exception.to_s)
      false
    else
      true
    end
  end

  def create_moderate_task
    @task = ModerateUserRegistration.new
    @task.user_id = self.id
    @task.name = self.name
    @task.email = self.email
    @task.target = self.environment
    @task.requestor = self.person
    @task.save
  end

  def activated?
    self.activation_code.nil? && !self.activated_at.nil?
  end

  class UnsupportedEncryptionType < Exception; end

  def self.system_encryption_method
    @system_encryption_method || :salted_sha1
  end

  def self.system_encryption_method=(method)
    @system_encryption_method = method
  end

  # a Hash containing the available encryption methods. Keys are symbols,
  # values are Proc objects that contain the actual encryption code.
  def self.encryption_methods
    @encryption_methods ||= {}
  end

  # adds a new encryption method.
  def self.add_encryption_method(sym, &block)
    encryption_methods[sym] = block
  end

  # the encryption method used for this instance
  def encryption_method
    (password_type || User.system_encryption_method).to_sym
  end

  # Encrypts the password using the chosen method
  def encrypt(password)
    method = self.class.encryption_methods[encryption_method]
    if method
      method.call(password, salt)
    else
      raise UnsupportedEncryptionType, "Unsupported encryption type: #{encryption_method}"
    end
  end

  add_encryption_method :salted_sha1 do |password, salt|
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  add_encryption_method :md5 do |password, salt|
    Digest::MD5.hexdigest(password)
  end

  add_encryption_method :salted_md5 do |password, salt|
    Digest::MD5.hexdigest(password+salt)
  end

  add_encryption_method :clear do |password, salt|
    password
  end

  add_encryption_method :crypt do |password, salt|
    password.crypt(salt)
  end

  def authenticated?(password)
    result = (crypted_password == encrypt(password))
    if (encryption_method != User.system_encryption_method) && result
      self.password_type = User.system_encryption_method.to_s
      self.password = password
      self.password_confirmation = password
      self.save!
    end
    result
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(:validate => false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(:validate => false)
  end

  # Exception thrown when #change_password! is called with a wrong current
  # password
  class IncorrectPassword < Exception; end

  # Changes the password of a user.
  #
  # * Raises IncorrectPassword if <tt>current</tt> is different from the user's
  #   current password.
  # * Saves the record unless it is a new one.
  def change_password!(current, new, confirmation)
    unless self.authenticated?(current)
      self.errors.add(:current_password, _('does not match.'))
      raise IncorrectPassword
    end
    self.force_change_password!(new, confirmation)
  end

  # Changes the password of a user without asking for the old password. This
  # method is intended to be used by the "I forgot my password", and must be
  # used with care.
  def force_change_password!(new, confirmation)
    self.password = new
    self.password_confirmation = confirmation
    save! unless new_record?
  end

  def name
    name = (self[:name] || login)
    person.nil? ? name : (person.name || name)
  end

  def name= name
    self[:name] = name
  end

  def enable_email!
    self.update_attribute(:enable_email, true)
  end

  def disable_email!
    self.update_attribute(:enable_email, false)
  end

  def email_activation_pending?
    if self.environment.nil?
      return false
    else
      return EmailActivation.exists?(:requestor_id => self.person.id, :target_id => self.environment.id, :status => Task::Status::ACTIVE)
    end
  end

  def moderate_registration_pending?
    return ModerateUserRegistration.exists?(:requestor_id => self.person.id, :target_id => self.environment.id, :status => Task::Status::ACTIVE)
  end

  def data_hash(gravatar_default = nil)
    friends_list = {}
    enterprises = person.enterprises.map { |e| { 'name' => e.short_name, 'identifier' => e.identifier } }
    self.person.friends.online.map do |person|
      friends_list[person.identifier] = {
        'avatar' => person.profile_custom_icon(gravatar_default),
        'name' => person.short_name,
        'jid' => person.full_jid,
        'status' => person.user.chat_status,
      }
    end

    {
      'login' => self.login,
      'avatar' => self.person.profile_custom_icon(gravatar_default),
      'is_admin' => self.person.is_admin?,
      'since_month' => self.person.created_at.month,
      'since_year' => self.person.created_at.year,
      'email_domain' => self.enable_email ? self.email_domain : nil,
      'friends_list' => friends_list,
      'enterprises' => enterprises,
      'amount_of_friends' => friends_list.count,
      'chat_enabled' => person.environment.enabled?('xmpp_chat')
    }
  end

  def self.expires_chat_status_every
    15 # in minutes
  end


  def not_require_password!
    @is_password_required = false
  end

  protected

    def normalize_email
      self.email = self.email.squish.downcase
    end

    # before filter
    def encrypt_password
      return if password.blank?
      self.salt ||= Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.password_type ||= User.system_encryption_method.to_s
      self.crypted_password = encrypt(password)
    end

    def password_required?
      (crypted_password.blank? || !password.blank?) && is_password_required?
    end

    def is_password_required?
      @is_password_required.nil? ? true : @is_password_required
    end

    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)
    end

    def deliver_activation_code
      return if person.is_template?
      UserMailer.activation_code(self).deliver unless self.activation_code.blank?
    end

    def delay_activation_check
      return if person.is_template?
      Delayed::Job.enqueue(UserActivationJob.new(self.id), {:priority => 0, :run_at => (NOOSFERO_CONF['hours_until_user_activation_check'] || 72).hours.from_now})
    end
end
