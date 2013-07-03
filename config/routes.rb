Foreman::Application.routes.draw do
  namespace :repositories do
    resources :providers
  end
end
