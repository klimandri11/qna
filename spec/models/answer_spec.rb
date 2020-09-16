require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'choose_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user, best: true) }
    let!(:answer_2) { create(:answer, question: question, user: user) }

    it 'set true for a best answer' do
      answer_2.choose_best

      expect(answer_2).to be_best
    end

    it 'one best answer' do
      answer_2.choose_best

      expect(question.answers.where(best: true).count).to eq 1
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
