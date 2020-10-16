Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :badges, only: %i[index]

  concern :votable do
    member do
      post :vote_for, :vote_against
      delete :unvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true do
      patch :choose_best, on: :member
    end
  end
end
