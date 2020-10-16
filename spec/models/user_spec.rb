require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:badges).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  describe 'author of the question' do
    let(:user) { create(:user) }
    let(:user_2) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'valid' do
      it 'compares user and author' do
        expect(user).to be_author_of(question)
      end
    end

    context 'invalid' do
      it 'compares user and author' do
        expect(user_2).to_not be_author_of(question)
      end
    end
  end
end
