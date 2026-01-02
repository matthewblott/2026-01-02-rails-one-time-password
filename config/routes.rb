Rails.application.routes.draw do
  get  "sign_in", to: "sessions#new"
  post "send_otp", to: "sessions#send_otp"
  get  "validate_otp", to: "sessions#validate_otp"
  post "sign_in", to: "sessions#create"
  post "sign_out", to: "sessions#destroy"

  get "about", to: "home#about"
  root "home#index"
end
