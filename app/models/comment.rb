class Comment < ApplicationRecord
  belongs_to :media_item
  belongs_to :user, optional: true

  validates :content, presence: true

  # JSON representation for API responses
  def as_json(options = {})
    super({
      only: [:id, :content, :created_at],
      methods: [:user_info]
    }.merge(options || {}))
  end

  # Include user info (anonymous if no user)
  def user_info
    if user
      { id: user.id, email: user.email }
    else
      { id: nil, email: 'Anonymous' }
    end
  end
end
