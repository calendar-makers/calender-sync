class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_root, only: [:new, :create]

  def create
    @user = User.new email: params[:user][:email], password: params[:user][:password]
    if @user.save
      flash[:notice] = "Account successfully created"
      redirect_to calendar_path
    else
      flash[:notice] = @user.errors.full_messages.join(", ").html_safe 
      redirect_to new_account_path
    end
  end

  private
  def is_root
    if not current_user.root?
      flash[:notice] = "You must be root admin to access this action"
      redirect_to calendar_path
    end
  end
end
