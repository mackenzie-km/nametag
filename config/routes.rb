Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "application#index"

  resources :contacts
  resources :events
  resources :users, only: [:index, :new, :edit, :create, :update, :destroy]

  get "contacts/:id/delete", to: "contacts#destroy"
  get "events/:id/delete", to: "events#destroy"
  get "users/:id/edit", to: "users#edit"
end
