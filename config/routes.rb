Rails.application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => "callbacks"}
  resource :calendar, :only => [:show]
  resources :events do
    collection do
      get 'third_party'
      post 'third_party'
      post 'pull_third_party'
    end
  end
  resources :guests
  get '/', to: redirect('/calendar')

  match "/auth/:provider/callback" => "sessions#create", via: [:get,:post]
  match "/signout" => "sessions#destroy", via: [:get]
  match "/auth/failure" => "sessions#failure", via: [:get]
end
