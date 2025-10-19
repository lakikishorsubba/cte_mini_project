Rails.application.routes.draw do
  # Root path of the application
  # This is the page that loads when someone visits your app at "/"
  root "todos#index"

  # Devise routes for user authentication
  # We override only the sessions controller to set JWT cookies after sign-in
  # and clear them on sign-out. Registrations controller is default.
  devise_for :users,
             controllers: {
               sessions: 'users/sessions'
             }

  # Resources for Todos
  # Standard RESTful routes: index, show, new, create, edit, update, destroy
  # Protected via `before_action :authenticate_user!` in TodosController
  resources :todos

end
