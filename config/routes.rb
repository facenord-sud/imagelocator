Rails.application.routes.draw do
  localized do
    root 'images#index'
    resources :user, only: :show do
      get :notifications
      get :images
    end

    resources :images, only: [:new, :create, :show] do
      get '/wrong' => 'images#wrong'
      get '/delete' => 'images#delete'
      resources :votes, only: [:new, :create, :edit, :update] do
        collection do
          get '/unknow' => 'votes#unknow'
        end
      end
    end
  end
  devise_for :users, controllers: {registrations: 'users/registrations', omniauth_callbacks: 'omniauth_callbacks'}

  root 'images#index'
  get "images/update_text", as: "update_text"
  get '/tags/search' => 'tags#search'
end
