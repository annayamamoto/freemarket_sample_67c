Rails.application.routes.draw do
  
  root "posts#index"
  get 'posts/index'
  get 'posts/show'
  post 'items/create'
 
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }
  
  devise_scope :user do
    get 'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
    get '/users/sign_out' => 'devise/sessions#destroy'
    # get '/users' => 'devise/registrations#create'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :buyers, only: [:index] do
    collection do
      post 'pay', to: 'buyers#pay'
      get 'done', to: 'buyers#done'
    end
  end
  resources :cards, only: [:new, :show] do
    collection do
      get 'show', to: 'cards#show'
      post 'pay', to: 'cards#pay'
      post 'destroy', to: 'cards#destroy'
    end
  end

end
