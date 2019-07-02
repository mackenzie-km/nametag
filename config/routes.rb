Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "application#index"

  resources :contacts
  resources :events
  resources :users, only: [:index, :new, :edit, :create, :update, :destroy]

  resources :contacts, only: [:index] do
    resources :events, only: [:index]
  end

  resources :events, only: [:index] do
    resources :contacts, only: [:index]
  end

  get "contacts/:id/delete", to: "contacts#destroy"
  get "events/:id/delete", to: "events#destroy"
  get "users/:id/edit", to: "users#edit"
end
