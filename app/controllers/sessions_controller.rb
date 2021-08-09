class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user.activated
      login user
    else
      flash[:warning] = t "user_mailer.account_activation.require_activated"
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
  def login user
    if user.activated
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash[:warning] = t "user_mailer.account_activation.require_activated"
      redirect_to root_url
    end
  end
end
