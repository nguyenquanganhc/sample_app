class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.all.page(params[:page]).per Settings.pagination.per_number
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "success_signup"
      redirect_to @user
    else
      flash[:danger] = t "fail_signup"
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash[:danger] = t "fail_updated"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "success_deleted"
    else
      flash[:danger] = t "fail_deleted"
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit User::USER_ATTRS
  end

  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "require_login"
    redirect_to login_path
  end

  # Confirm the correct user
  def correct_user
    redirect_to root_path unless current_user? @user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "invalid_user"
    redirect_to root_path
  end
end
