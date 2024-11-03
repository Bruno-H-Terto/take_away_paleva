Rails.application.routes.draw do
  devise_for :owners, controllers: {
    sessions: 'owners/sessions',
    registrations: 'owners/registrations'
  }
  root "home#index"
  get "owner" => "home#owner", as: 'owner'
  resources :take_away_stores, only: %i[new create show edit update] do
    get 'search', on: :collection
    resources :business_hours, only: %i[new create edit update index]
    resources :items, only: %i[index] do
      patch 'change_status', on: :member
      resources :portions, only: %i[create]
      resources :tags, only: %i[new create]
    end
    resources :dishes, only: %i[new create show edit update destroy]
    resources :beverages, only: %i[new create show edit update destroy]
  end

  resources :portions, only: %i[show update]
end
