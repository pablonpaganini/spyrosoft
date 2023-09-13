Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # resources :tableros, only: [:show, :update]
  get "/tablero", to: "tableros#show"
  get "/tablero/update", to: "tableros#update", as: "tablero_update"
  get "/tablero/reset", to: "tableros#reset", as: "tablero_reset"
end
