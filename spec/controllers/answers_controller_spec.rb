require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database by user' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(user.answers, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(question.answers, :count)
        end

        it 're-renders new view' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'Unauthenticated user' do
      it 'try to create answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:user_2) { create(:user) }
    context 'Authenticated user' do
      context 'Author' do
        before { login(user) }

        it 'try to delete their answer' do
          expect { delete :destroy, params: { id: answer } }.to change(user.answers, :count).by(-1)
        end

        it 'redirect' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'Not author' do
        before { login(user_2) }

        it "try to delete someone else's question" do
          expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
        end

        it 'redirect' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'try to delete the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
