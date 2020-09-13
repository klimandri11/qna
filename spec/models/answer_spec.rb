require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'choose_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it 'set true for a best answer' do
      create_list(:answer, 4, question: question, user: user)
      answer.choose_best

      expect(question.answers.where(best: true).count).to eq 1
      expect(question.answers.find_by(id: answer).best).to eq true
    end
  end
end
