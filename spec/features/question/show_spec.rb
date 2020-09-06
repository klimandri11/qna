require 'rails_helper'

feature 'User can browse the question and its answers', %q{
  To find the answer to the question
  I'd like to view a list of answers to the it
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 4, question: question, user: user) }

  scenario 'User tries browse the question and its answers' do
    visit questions_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
