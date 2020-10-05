require 'rails_helper'

RSpec.describe BadgesController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:badge) { create(:badge, question: question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 4, user: user) }

    before do
      login(user)
      get :index
    end

    it 'fills the badge array' do
      expect(assigns(:badges)).to match_array(user.badges)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

end
