Rails.application.routes.draw do
  devise_for :owners, controllers: {
    sessions: 'owners/sessions',
    registrations: 'owners/registrations'
  }
  root "home#index"

  resources :take_away_stores, only: %i[new create show edit update] do
    resources :business_hours, only: %i[new create edit update]
    resources :items, only: %i[index]
    resources :dishes, only: %i[new create show edit update]
    resources :beverages, only: %i[new create show edit update]
  end
end
