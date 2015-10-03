# encoding: UTF-8
class Post < ActiveRecord::Base
  # Associations
  belongs_to :council
  has_many :post_users
  has_many :users, through: :post_users
  has_and_belongs_to_many :elections
  has_many :nominations
  has_many :candidates
  has_many :permission_posts
  has_many :permissions, through: :permission_posts

  # Scopes
  scope :studierad, -> { where(elected_by: 'Studierådet').order(council_id: :asc) }
  scope :termins, -> { where(elected_by: 'Terminsmötet').order(council_id: :asc) }

  scope :not_termins, -> { where.not(elected_by: 'Terminsmötet').order(council_id: :asc) }

  # Validations
  validates :limit, :recLimit, :description, presence: true

  # Scopes
  scope :renters, -> { where(car_rent: true) }
  scope :title, -> { order(title: :asc) }

  def to_s
    title
  end

  def print_limit
    if recLimit == 0 && limit == 0 || recLimit > limit
      "*"
    elsif recLimit == limit && recLimit > 0
      %(#{limit}  (x))
    elsif limit > 0 && recLimit == 0
      limit
    elsif limit > recLimit
      %(#{recLimit}- #{limit})
    end
  end

  def limited?
    limit > 0 && users.count >= limit
  end

  def set_permissions(params)
    self.permissions = []
    params[:permission_ids].each do |id|
      if id.present?
        permissions << Permission.find(id)
      end
    end
    save!
  end
end
