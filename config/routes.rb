Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "application#index"

# creating model routes - note that user does not need show page
  resources :contacts
  resources :events
  resources :users, only: [:index, :new, :edit, :create, :update, :destroy]

# creating nested routes for contact/:id/events & events/:id/contacts
  resources :contacts, only: [:index] do
    resources :events, only: [:index]
  end
  resources :events, only: [:index] do
    resources :contacts, only: [:index, :new, :create]
  end

# custom routes for login & logout
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "logout", to: "sessions#destroy"

# custom routes for google auth
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/login')
end
