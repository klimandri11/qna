class Answer < ApplicationRecord

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_answer, -> { order(best: :desc) }

  def choose_best
    Answer.transaction do
      question.answers.where(best: true).first&.update!(best: false)
      update!(best: true)
    end
  end
end
