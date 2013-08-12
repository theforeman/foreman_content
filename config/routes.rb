Rails.application.routes.draw do
  scope :module => :content do
    resources :gpg_keys do
      collection do
        get 'auto_complete_search'
      end
    end

    resources :content_views do
      collection do
        get 'auto_complete_search'
      end
    end

    resources :products do
      collection do
        get 'auto_complete_search'
      end
      member do
        put :sync
      end
    end

    resources :repositories do
      collection do
        get 'auto_complete_search'
      end
      member do
        put :sync
      end
    end

    namespace :api do
      resources :repositories do
        collection do
          post 'events'
        end
      end
    end

  end
end