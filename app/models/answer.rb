class Answer < ApplicationRecord

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :best_answer, -> { order(best: :desc) }

  def choose_best
    Answer.transaction do
      question.answers.where(best: true).first&.update!(best: false)
      update!(best: true)
      question.badge&.update!(user: user)
    end
  end
end
