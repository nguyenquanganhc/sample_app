class Micropost < ApplicationRecord
  MICROPOST_ATTRS = %i(content image).freeze

  belongs_to :user
  has_one_attached :image
  scope :newest, ->{order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.micropost.max_length}
  validates :image,
            content_type: {
              in: Settings.image_restricted_types,
              message: I18n.t("image_type")
            },
            size: {
              less_than: Settings.image.size.megabytes,
              message: I18n.t("image_size", size: Settings.image.size)
            }

  def display_image
    image.variant resize_to_limit: Settings.image.limit
  end
end
