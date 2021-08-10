class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if check_activatable user
      user.activate
      log_in user
      flash[:success] = t "user_mailer.account_activation.activated"
      redirect_to user
    else
      flash[:danger] = t "user_mailer.account_activation.invalid_link"
      redirect_to root_path
    end
  end

  private
  def check_activatable user
    user && !user.activated && user.authenticated?(:activation, params[:id])
  end
end
