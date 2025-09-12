class CommentsController < ApplicationController
  before_action :set_media_item
  before_action :set_comment, only: [:destroy]
  before_action :authenticate_user!, only: [:create, :destroy]

  # GET /media_items/:media_item_id/comments
  def index
    @comments = @media_item.comments.order(created_at: :asc)
    render json: @comments
  end

  # POST /media_items/:media_item_id/comments
  def create
    @comment = @media_item.comments.build(comment_params)
    @comment.user = current_user if current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /media_items/:media_item_id/comments/:id
  def destroy
    if @comment.user_id.nil? || @comment.user_id == current_user&.id
      @comment.destroy
      head :no_content
    else
      render json: { error: 'Not authorized' }, status: :forbidden
    end
  end

  private

  def set_media_item
    @media_item = MediaItem.find(params[:media_item_id])
  end

  def set_comment
    @comment = @media_item.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
