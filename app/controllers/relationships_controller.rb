class RelationshipsController < ApplicationController
  before_action :logged_in_user
  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow(@user)
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
      redirect_to user
    else
      flash[:danger] = t "not_found"
      redirect_to root_path
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    if @user
      current_user.unfollow(@user)
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
      redirect_to user
    else
      flash[:danger] = t "not_found"
      redirect_to root_path
    end
  end
end
