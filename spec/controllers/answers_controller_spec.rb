require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'saves a new answer in the database by user' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(user.answers, :count).by(1)
        end

        it 'render create template' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
        end

        it 'render create template' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
          expect(response).to render_template :create
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
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'Not author' do
        before { login(user_2) }

        it "try to delete someone else's question" do
          expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
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

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user' do
      context 'author' do
        before { login(user) }

        context 'with valid attributes' do
          it 'changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'renders update template' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          it 'does not change answer attributes' do
            expect do
              patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            end.to_not change(answer, :body)
          end

          it 'renders update template' do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            expect(response).to render_template :update
          end
        end
      end

      context 'Not author' do
        before { login(user_2) }

        it 'does not update answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          answer.reload
          expect(answer.body).to eq answer.body
        end
      end
    end

    context 'Unauthenticated user' do
      it 'try to update the answer' do
        expect { patch :update, params: { id: answer, answer: { body: 'new body' } } }.not_to change(Answer, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #choose_best' do
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user' do
      context 'Author' do
        before { login(user) }

        it 'the answer best is true' do
          patch :choose_best, params: { id: answer }, format: :js
          answer.reload

          expect(answer.best).to eq true
        end

        it 'render choose_best template' do
          patch :choose_best, params: { id: answer }, format: :js

          expect(response).to render_template :choose_best
        end
      end

      context 'Not author' do
        before { login(user_2) }

        it 'the answer best is false' do
          patch :choose_best, params: { id: answer }, format: :js
          answer.reload

          expect(answer.best).to eq false
        end

        it 'render choose_best template' do
          patch :choose_best, params: { id: answer }, format: :js

          expect(response).to render_template :choose_best
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not change answer' do
        patch :choose_best  , params: { id: answer, answer: { best: true }, format: :js }
        answer.reload
        expect(answer.best).to_not eq true
      end
    end
  end
end
