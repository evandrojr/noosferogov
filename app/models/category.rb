class Category < ActiveRecord::Base

  validates_exclusion_of :slug, :in => [ 'index' ], :message => N_('%{fn} cannot be like that.')
  validates_presence_of :name, :environment_id
  validates_uniqueness_of :slug,:scope => [ :environment_id, :parent_id ], :message => N_('%{fn} is already being used by another category.')
  belongs_to :environment

  validates_inclusion_of :display_color, :in => [ 1, 2, 3, 4, nil ]
  validates_uniqueness_of :display_color, :scope => :environment_id, :if => (lambda { |cat| ! cat.display_color.nil? }), :message => N_('%{fn} was already assigned to another category.')

  def validate
    if self.parent && (self.class != self.parent.class)
      self.errors.add(:type, _("%{fn} must be the same as the parents'"))
    end
  end

  # Finds all top level categories for a given environment. 
  def self.top_level_for(environment)
    self.find(:all, :conditions => ['parent_id is null and environment_id = ?', environment.id ])
  end

  acts_as_filesystem

  has_and_belongs_to_many :articles
  def recent_articles(limit = 10)
    self.articles.recent(limit)
  end

  def recent_comments(limit = 10)
    # FIXME this can become SLOW
    Comment.find(:all, :order => 'created_on DESC, comments.id DESC', :limit => limit, :conditions => { :article_id => article_ids})
  end

  def most_commented_articles(limit = 10)
    self.articles.most_commented(limit)
  end
end
