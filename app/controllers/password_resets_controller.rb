class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".sent_email"
      redirect_to root_path
    else
      flash[:danger] = t ".email_address_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if user_params[:password].blank?
      @user.errors.add :password, t(".empty_password")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t ".password_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit User::RESET_PASSWORD_ATTRS
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user&.activated && @user&.authenticated?(:reset, params[:id])

    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_expired"
    redirect_to new_password_reset_path
  end
end
