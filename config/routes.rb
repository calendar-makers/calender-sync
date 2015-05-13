Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
  end

  resource :calendar, :only => [:show]

  resources :events do
    collection do
      get 'third_party'
      post 'third_party'
      post 'pull_third_party'
    end
  end
  post '/events/:id', to: 'events#update'
  resources :guests, :only => [:new, :create]
  resources :accounts
  #get '/', to: redirect('/calendar')
  root 'calendars#show'
end
