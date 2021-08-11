class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t ".create_post"
      redirect_to root_path
    else
      flash[:danger] = t ".fail_post"
      @feed_items = current_user.feed.page params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".delete_post"
    else
      flash[:danger] = t ".delete_fail"
    end
    redirect_to request.referer || root_path
  end

  private
  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_ATTRS
  end

  def correct_user
    @micropost = current_user.microposts.newest.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "invalid_user"
    redirect_to request.referer || root_path
  end
end
