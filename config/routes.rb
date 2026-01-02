Rails.application.routes.draw do
  get  "sign_in", to: "sessions#new"
  post "send_otp", to: "sessions#send_otp"
  get  "validate_otp", to: "sessions#validate_otp"
  post "sign_in", to: "sessions#create"

  # get  "enter_otp", to: "sessions#enter_otp"
  # post "enter_otp", to: "sessions#create"

  resources :sessions, only: [:index, :show, :destroy]

  get "about", to: "home#about"
  root "home#index"
end
