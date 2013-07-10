module Foreman
  Application.routes.draw do
    namespace :repositories do
      resources :providers do
        collection do
          get 'auto_complete_search'
        end
      end

      resources :gpg_keys do
        collection do
          get 'auto_complete_search'
        end
      end

      resources :products do
        collection do
          get 'auto_complete_search'
        end
      end
    end
  end
end
