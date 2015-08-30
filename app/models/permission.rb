class Permission < ActiveRecord::Base
  has_many :posts, through: :permission_posts
  has_many :permission_posts
  validates :subject_class, :action, presence: true

  def to_s
    %(#{subject_class} - #{action})
  end
end
