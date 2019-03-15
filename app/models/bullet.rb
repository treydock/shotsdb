class Bullet < ApplicationRecord
  include UserOwned
  belongs_to :caliber
  validates :name, presence: true, uniqueness: { scope: [:caliber, :user] }
  validates :caliber, presence: true
  validates :grain, numericality: { only_integer: true }

  def name_caliber_grain
    "#{name} (#{caliber.name} - #{grain}gr)"
  end
end
