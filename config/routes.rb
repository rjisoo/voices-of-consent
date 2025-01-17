require 'sidekiq/web'

Rails.application.routes.draw do
  resources :purchases
  resources :inventory_adjustments
  resources :inventory_tallies
  resources :inventory_types
  resources :locations
  resources :meeting_types
  resources :attendances
  resources :box_request_abuse_types
  resources :message_logs
  devise_for :users, controllers: {
    passwords: 'users/passwords', sessions: "users/sessions", invitations: "users/invitations"
  }
  devise_scope :users do
    authenticated :user do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  resources :meetings
  resources :boxes
  resources :volunteers
  resources :box_requests
  resources :requesters, only: [:new]

  get 'login_demo/index'
  get 'contact', to: 'home#contact'
  get 'admin', to: 'home#admin'

  get 'box_design/new', to: 'box_design#new'
  get 'box_design/claim/:box_id', to: 'box_design#claim'
  post 'box_design/mark_as_designed', to: 'box_design#mark_as_designed'

  get 'box_assembly/new', to: 'box_assembly#new'
  get 'box_assembly/claim/:box_id', to: 'box_assembly#claim'
  post 'box_assembly/mark_as_assembled/:box_id', to: 'box_assembly#mark_as_assemblyed'

  resource :user_management, only: %i[show create destroy], controller: :user_management

  post 'box_request_triage', to: "box_request_triage#create"
  get 'box_request/already_claimed', to: 'box_requests#already_claimed'

  get 'box_shipment/claim/:box_id', to: 'box_shipment#claim'
  post 'box_shipment/mark_as_shipped', to: 'box_shipment#mark_as_shipped'

  # For details on the DSL available within this file, see
  # http://guides.rubyonrails.org/routing.html
  root 'home#index'
end
