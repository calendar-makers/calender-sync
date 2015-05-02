Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
    put 'users/:id' => 'devise/registrations#update', :as => 'user_registration'            
  end

  resource :calendar, :only => [:show] do
    collection do
      get 'show_event'
      post 'create_guest'
      post 'show_edit'
      post 'show_new'
    end
  end

  resources :events do
    collection do
      get 'third_party'
      post 'third_party'
      post 'pull_third_party'
    end
  end
  post '/events/:id', to: 'events#update'
  resource :guests, :only => [:create]
  resources :accounts
  get '/', to: redirect('/calendar')
end
