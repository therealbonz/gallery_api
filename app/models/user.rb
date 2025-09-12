# app/models/user.rb
class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_one_attached :avatar
  has_many :media_items, dependent: :nullify
  has_many :comments, dependent: :nullify
end