class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_root, only: [:new, :create]

  def new
    form_validation_msg
  end

  def create
    @user = User.new email: params[:user][:email], password: params[:user][:password]
    if @user.save
      redirect_to calendar_path
    else
      flash[:notice] = @user.errors.full_messages.join("</br>").html_safe 
      render :new
    end
  end

  def edit
  end

  def update
  end

  private
  def is_root
    if not current_user.root?
      flash[:notice] = "You must be root admin to access this action"
      redirect_to calendar_path
    end
  end

  def form_validation_msg
    @message = flash[:notice] || ''
    if flash[:notice].respond_to? :join
      @message = 'Please fill in the following fields before submitting: ' + flash[:notice].join(', ')
    end
  end
end
