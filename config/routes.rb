Rails.application.routes.draw do
  # Devise Token Auth routes for User
  mount_devise_token_auth_for 'User', at: 'auth'

  # MediaItems routes
  resources :media_items do
    # Custom member route for liking
    member { post :like }

    # Custom collection route for reordering
    collection { patch :reorder }

    # Nested comments routes
    resources :comments, only: %i[index create destroy]
  end

  # User-specific routes
  get  'users/me', to: 'users#me'
  patch 'users/avatar', to: 'users#update_avatar'

  # Optional root route
  root "media_items#index"

  # API namespace for custom endpoints
  namespace :api do
    resources :media_items do
      collection do
        get :my_images  # /api/media_items/my_images
      end
    end
  end
end
