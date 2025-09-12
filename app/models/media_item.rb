# app/models/media_item.rb
class MediaItem < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :file
  has_many :comments, dependent: :destroy

  # Default likes count
  attribute :likes_count, :integer, default: 0

  # Auto-assign sequential position
  before_create :set_position

  # Validations
  validates :title, presence: true
  validate :acceptable_file
  validates :media_type, inclusion: { in: %w[image video gif] }, allow_blank: true

  private

  # Ensure file is attached, type and size are valid
  def acceptable_file
    return unless file.attached?

    allowed_types = %w[image/png image/jpeg image/gif video/mp4 video/webm video/ogg]
    unless allowed_types.include?(file.content_type)
      errors.add(:file, "must be an image (png/jpeg/gif) or video (mp4/webm/ogg)")
    end

    max_size = 20.megabytes
    if file.byte_size > max_size
      errors.add(:file, "is too big. Max size is #{max_size / 1.megabyte} MB")
    end
  end

  # Sequential position assignment
  def set_position
    self.position ||= (MediaItem.maximum(:position) || 0) + 1
  end

  public

  # Determine simplified type based on content_type
  def file_kind
    return 'video' if file.content_type&.start_with?('video')
    return 'gif' if file.content_type == 'image/gif'
    'image'
  end

  # Full URL to the attached file
  def file_url
    Rails.application.routes.url_helpers.url_for(file) if file.attached?
  end

  # Preview URL for images (resized) or fallback to file_url
  def preview_url
    return file_url unless file.content_type&.start_with?('image')
    variant = file.variant(resize_to_limit: [600, 600]).processed
    Rails.application.routes.url_helpers.url_for(variant)
  end

  # Info about the uploader
  def user_info
    return nil unless user
    {
      id: user.id,
      email: user.email,
      avatar_url: (Rails.application.routes.url_helpers.url_for(user.avatar) if user.avatar&.attached?)
    }
  end

  # Customize JSON output
  def as_json(options = {})
    super({
      only: %i[id title description position likes_count created_at],
      methods: [:file_kind, :file_url, :preview_url, :user_info]
    }.merge(options || {}))
  end
end
