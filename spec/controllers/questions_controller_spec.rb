require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question} }
    let!(:answer) { create(:answer, question: question, user: user) }

    it 'the answer is associated with the question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
      expect(assigns(:question)).to eq answer.question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'Authenticated user' do
      before do
        login(user)
        get :new
      end

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'Unauthenticated user' do
      before { get :new }

      it 'try to render new view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    context 'Authenticated user' do
      before { login(user) }
      before { get :edit, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'Unauthenticated user' do
      before { get :edit, params: { id: question } }

      it 'try to render edit view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database by author user' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      it 'try to save the question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end

      it 'redirect to new user' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PACH #update' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirects to update questions' do
          patch :update, params: { id: question, question: attributes_for(:question) }

          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question,  question: attributes_for(:question, :invalid) } }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'Unauthenticated user' do
      it 'trying to change the question' do
        patch :update, params: { id: question,  question: attributes_for(:question) }
        expect(assigns(:question)).to_not eq question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:user_2) { create(:user) }

    context 'Authenticated user' do
      context 'Author' do
        before { login(user) }

        it 'delete the question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'redirect to index view' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'Not author' do
        before { login(user_2) }

        it "trying to delete someone else's question" do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end
    end

    context 'Unauthenticated user' do
      it 'trying to delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
