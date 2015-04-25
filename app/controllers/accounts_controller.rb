class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_root, only: [:new, :create]

  # GET /accounts/new
  def new
    form_validation_msg
  end

  def create
    User.create_non_root(params)
    redirect_to '/'
  end

  def edit
  end

  def update
  end

  private
  def is_root
    redirect '/' if not current_user.root?
  end

  def form_validation_msg
    @message = flash[:notice] || ''
    if flash[:notice].respond_to? :join
      @message = 'Please fill in the following fields before submitting: ' + flash[:notice].join(', ')
    end
  end
end
