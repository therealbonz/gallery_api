# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:me, :update_avatar]

  def me
    u = current_user
    render json: {
      id: u.id,
      email: u.email,
      avatar_url: (url_for(u.avatar) if u.avatar.attached?)
    }
  end

  def update_avatar
    current_user.avatar.attach(params[:avatar]) if params[:avatar]
    render json: { avatar_url: (url_for(current_user.avatar) if current_user.avatar.attached?) }
  end
end