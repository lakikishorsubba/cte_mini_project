Rails.application.routes.draw do
  # Root path of the application
  # This is the page that loads when someone visits your app at "/"
  root "todos#index"

  # Devise routes for user authentication
  # We override only the sessions controller to set JWT cookies after sign-in and clear them on sign-out
  # Registrations controller is kept default (or you can override later if needed)
  devise_for :users,
             controllers: {
               sessions: 'users/sessions'
             }

  # Resources for Todos
  # Standard RESTful routes: index, show, new, create, edit, update, destroy
  # Protected via `before_action :authenticate_user!` in TodosController
  resources :todos

  # Health check route
  # Optional endpoint that can be pinged by monitoring tools
  get "up" => "rails/health#show", as: :rails_health_check
end
