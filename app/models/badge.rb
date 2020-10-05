class Badge < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :image, dependent: :destroy

  validates :name, presence: true
end
