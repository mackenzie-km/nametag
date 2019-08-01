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
    resources :contacts, only: [:index]
  end

# custom
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "logout", to: "sessions#destroy"

  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/login')

  get 'events/:event_id/contacts/new', to: 'contacts#new'
  post 'events/:event_id/contacts', to: 'contacts#create'
end
