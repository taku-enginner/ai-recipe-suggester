require 'sidekiq/web'

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "recipes#new"
  post "recipes", to: "recipes#create"
  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => "/cable"
end
