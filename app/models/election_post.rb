class ElectionPost < ActiveRecord::Base
  belongs_to :election, required: true
  belongs_to :post, required: true

  validates :post, uniqueness: { scope: :election }
end
