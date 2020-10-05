require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create :link, name: 'Rails', url: 'http://rusrails.ru', linkable: question }
  let(:user_2) { create(:user) }

  describe 'DELETE #destroy' do
    context 'Authenticate user' do
      context 'Author' do
        before { login(user) }

        it 'delete link' do
          expect { delete :destroy, params: { id: link.id }, format: :js }.to change(Link, :count).by(-1)
        end
      end

      context 'Not author' do
        before { login(user_2) }

        it "trying to delete someone else's link" do
          expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
        end
      end
    end

  context 'Unauthenticate user' do
    it 'trying to delete the link' do
      expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
    end
  end
end

end
