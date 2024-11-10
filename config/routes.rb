Rails.application.routes.draw do
  devise_for :owners, controllers: {
    sessions: 'owners/sessions',
    registrations: 'owners/registrations'
  }
  root "home#index"
  get "owner", to: "home#owner", as: 'owner'
  resources :take_away_stores, only: %i[new create show edit update] do
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
end
