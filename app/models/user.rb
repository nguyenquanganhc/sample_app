class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :downcase_email
  USER_ATTRS = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
            length: {maximum: Settings.name.max_length}
  validates :email, presence: true,
            length: {maximum: Settings.email.max_length},
            format: {with: Settings.email.valid_regex},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true,
            length: {minimum: Settings.password.min_length},
            allow_nil: true
  has_secure_password

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private
  def downcase_email
    email.downcase!
  end
end
