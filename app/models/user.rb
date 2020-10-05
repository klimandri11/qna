class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, dependent: :destroy

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def author_of?(resource)
    resource.user_id == id
  end
end
