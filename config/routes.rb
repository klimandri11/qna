Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :badges, only: %i[index]

  resources :questions do
    resources :answers, shallow: true do
      patch :choose_best, on: :member
    end
  end
end
