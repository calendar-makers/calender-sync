Rails.application.routes.draw do
  devise_for :users
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
end
