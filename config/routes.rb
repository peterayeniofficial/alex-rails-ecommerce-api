Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api do
    resources :books
    resources :authors
    resources :publishers

    get '/search/:text', to: 'search#index'
  end

  root to: 'books#index'
end
