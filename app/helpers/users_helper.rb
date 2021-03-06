module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user, options = {size: Settings.avatar.default_size}
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def load_followed_user user
    current_user.active_relationships.find_by followed_id: user.id
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "invalid_user"
    redirect_to root_path
  end
end
