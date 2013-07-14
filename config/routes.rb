Rails.application.routes.draw do
  scope :module => :content do
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

    resources :repositories do
      collection do
        get 'auto_complete_search'
      end
    end
  end
end