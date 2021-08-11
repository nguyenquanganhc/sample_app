class FollowingsController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @title = t "followings.index.following"
    @users = @user.following.page(params[:page])
                  .per Settings.pagination.per_number
    render "users/show_follow"
  end
end
