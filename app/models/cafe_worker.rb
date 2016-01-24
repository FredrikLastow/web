class CafeWorker < ActiveRecord::Base
  belongs_to :user
  belongs_to :cafe_shift
  has_many :cafe_worker_councils, dependent: :destroy
  has_many :councils, through: :cafe_worker_councils

  validates :user_id, :cafe_shift_id, presence: true
  validate :user_attributes?

  protected

  def user_attributes?
    if !user.try(:has_attributes?)
      errors.add(:user, I18n.t('user.attributes_missing'))
      false
    else
      true
    end
  end
end