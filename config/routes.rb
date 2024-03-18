Rails.application.routes.draw do
  root to: 'todo_lists#index'

  namespace :api do
    resources :todo_lists, only: %i[index show create update destroy], path: :todolists do
      resources :items, only: %i[index show create update destroy], path: :items
    end
  end

  resources :todo_lists, path: :todolists do
    resources :items, path: :items
  end

  match '*unmatched', to: 'application#render_not_found', via: :all
end
