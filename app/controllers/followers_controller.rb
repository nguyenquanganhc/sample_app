class FollowersController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @title = t "followers.index.follower"
    @users = @user.followers.page(params[:page])
                  .per Settings.pagination.per_number
    render "users/show_follow"
  end
end
