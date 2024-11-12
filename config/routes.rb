Rails.application.routes.draw do
  devise_for :owners, controllers: {
    sessions: 'owners/sessions',
    registrations: 'owners/registrations'
  }

  devise_for :employees, controllers: {
    sessions: 'employees/sessions',
    registrations: 'employees/registrations'
  }

  root "home#index"
  get "owner", to: "home#owner", as: 'owner'
  get 'create_account', to: 'home#create_account', as: 'new_registration'
  get 'sign_in_account', to: 'home#sign_in_account', as: 'new_session'
  resources :take_away_stores, only: %i[new create show edit update] do
    resources :employees, only: %i[index new create]
    resources :menus, only: %i[create show] do
      resources :item_menus, only: %i[create destroy]
    end
    get 'search', on: :collection
    resources :business_hours, only: %i[new create edit update index]
    resources :items, only: %i[index] do
      get 'historical', on: :member
      patch 'change_status', on: :member
      resources :portions, only: %i[create]
      resources :tags, only: %i[new create destroy]
    end
    resources :dishes, only: %i[new create show edit update destroy]
    resources :beverages, only: %i[new create show edit update destroy]
  end
  resources :characteristics, only: %i[index create show update]
  resources :portions, only: %i[show update]
  resources :order_items, only: %i[index create destroy edit update]
  resources :orders, only: %i[new create index show]
  get 'order_items/:menu_id/item/:item_id', to: 'order_items#cart', as: 'new_item'

  namespace :api do
    namespace :v1 do
      resources :orders, only: %i[index] do
        get 'status', on: :collection
      end
    end
  end
end
