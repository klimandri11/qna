class Answer < ApplicationRecord
  default_scope -> { order(best: :desc) }
  
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def choose_best
    Answer.transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
