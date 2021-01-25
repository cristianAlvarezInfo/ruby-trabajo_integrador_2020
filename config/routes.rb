Rails.application.routes.draw do
  
  resources :books do
    resources :notes
  end
  
  devise_for :users
  root "main#home"
  get '/export/:id', to: 'notes#export', as: 'export'
  get '/export_notes_of_book/:id', to: 'books#export_notes', as: 'export_notes_of_book'
  get '/export_all_notes', to: 'books#export_all_notes_of_current_user', as: 'export_all_notes'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
