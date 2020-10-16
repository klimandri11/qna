require 'rails_helper'

shared_examples_for 'votable' do
  model_klass = described_class.to_s

  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, user: user) }

  if model_klass == "Answer"
    let!(:votable) { create(model_klass.underscore.to_sym, question: question, user: user) }
  elsif model_klass == "Question"
    let!(:votable) { create(model_klass.underscore.to_sym, user: user) }
  end

  it '#vote_up' do
    votable.vote_up(user_2)
    expect(votable.votes.first.value).to eq 1
  end

  it '#vote_down' do
    votable.vote_down(user_2)
    expect(votable.votes.first.value).to eq -1
  end

  it '#unvote' do
    votable.vote_up(user_2)
    votable.unvote(user_2)
    expect(votable.sum_votes).to eq 0
  end
end
