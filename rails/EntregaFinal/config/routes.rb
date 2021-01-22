Rails.application.routes.draw do
  
  resources :books do
    resources :notes
  end
  
  devise_for :users
  root "main#home"
  get '/export/:id', to: 'notes#export', as: 'export'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
