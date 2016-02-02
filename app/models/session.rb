class Session < ActiveRecord::SessionStore::Session

  def self.find_by_session_id(session_id)
    where(session_id: session_id).all.first
  end

  belongs_to :user

  before_save :copy_to_columns

  protected

  def copy_to_columns
    self.user_id = self.data['user']
  end

end
