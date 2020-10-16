require 'rails_helper'

shared_examples_for 'voted' do
  model_klass = described_class.controller_name.classify.underscore

  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let(:question) { create(:question, user: user) }
  if model_klass.to_s == "answer"
    let!(:resource) { create(model_klass.to_sym, question: question, user: user) }
  elsif model_klass.to_s == "question"
    let!(:resource) { create(model_klass.to_sym, user: user) }
  end

  describe 'POST#vote_up' do
    context 'Authenticated user' do
      context 'Not author' do
        before { login(user_2) }

        it 'assigns a voting resource' do
          post :vote_for, params: { id: resource.id }, format: :json
          expect(assigns(:votable)).to eq resource
        end

        it 'creates a new vote' do
          expect do
            post :vote_for, params: { id: resource.id }, format: :json
            resource.reload
          end.to change(resource.votes, :count).by(1)
        end
      end
    end
  end

  describe 'POST#vote_down' do
    context 'Authenticated user' do
      context 'Not author' do
        before { login(user_2) }

        it 'assigns a voting resource' do
          post :vote_against, params: { id: resource.id }, format: :json
          expect(assigns(:votable)).to eq resource
        end

        it 'creates a new vote' do
          expect do
            post :vote_against, params: { id: resource.id }, format: :json
            resource.reload
          end.to change(resource.votes, :count).by(1)
        end
      end
    end
  end

  describe 'POST#unvote' do
    context 'Authenticated user' do
      context 'not author' do
        before { login(user_2) }

        it 'assigns a voting resource' do
          delete :unvote, params: { id: resource.id }, format: :json
          expect(assigns(:votable)).to eq resource
        end

        it 'deletes a vote' do
          expect do
            patch :vote_for, params: { id: resource.id }, format: :json
            delete :unvote, params: { id: resource.id }, format: :json
            resource.reload
          end.to change(resource.votes, :count).by(0)
        end
      end
    end
  end
end
