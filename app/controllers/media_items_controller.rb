# app/controllers/media_items_controller.rb
class MediaItemsController < ApplicationController
  before_action :set_media_item, only: %i[show update destroy like]

  # Public uploads allowed
  before_action :authenticate_user!, only: %i[update destroy reorder]

  # GET /media_items
  def index
  page     = (params[:page] || 1).to_i
  per_page = (params[:per_page] || 12).to_i

  media_items = MediaItem
                  .includes(file_attachment: :blob)
                  .order(position: :asc, created_at: :desc) # position first, fallback by created
                  .page(page)
                  .per(per_page)

  render json: {
    items: media_items.map { |item| media_item_json(item) },
    total_pages: media_items.total_pages,
    current_page: media_items.current_page
  }
end

  # GET /media_items/:id
  def show
    render json: media_item_json(@media_item)
  end

  # POST /media_items
  def create
    created_items = []

    # Handle multiple files
    if params[:media_item][:files].present?
      params[:media_item][:files].each do |file|
        item = MediaItem.new(title: params[:media_item][:title].presence || file.original_filename)
        item.file.attach(file)
        item.user = current_user if current_user
        created_items << media_item_json(item) if item.save
      end

    # Single file fallback
    elsif params[:media_item][:file].present?
      file = params[:media_item][:file]
      item = MediaItem.new(title: params[:media_item][:title].presence || file.original_filename)
      item.file.attach(file)
      item.user = current_user if current_user
      created_items << media_item_json(item) if item.save

    else
      return render json: { errors: ["No files provided"] }, status: :unprocessable_content
    end

    if created_items.any?
      render json: created_items, status: :created
    else
      render json: { errors: ["Failed to save any files"] }, status: :unprocessable_content
    end
  rescue StandardError => e
    render json: { errors: [e.message] }, status: :internal_server_error
  end

  # PATCH /media_items/:id
  def update
    if @media_item.user_id.nil? || @media_item.user_id == current_user&.id
      if @media_item.update(media_item_params)
        render json: media_item_json(@media_item)
      else
        render json: { errors: @media_item.errors.full_messages }, status: :unprocessable_content
      end
    else
      render json: { error: 'Not authorized' }, status: :forbidden
    end
  end

  # PATCH /media_items/reorder
  def reorder
    ids = params[:order] || []
    ActiveRecord::Base.transaction do
      ids.each_with_index do |id, idx|
        MediaItem.where(id: id).update_all(position: idx + 1)
      end
    end
    head :no_content
  end

  # POST /media_items/:id/like
  def like
    @media_item.increment!(:likes_count)
    render json: { id: @media_item.id, likes_count: @media_item.likes_count }
  end

  # DELETE /media_items/:id
  def destroy
    if @media_item.user_id.nil? || @media_item.user_id == current_user&.id
      @media_item.destroy
      render json: { message: "Deleted" }
    else
      render json: { error: 'Not authorized' }, status: :forbidden
    end
  end

  private

  def set_media_item
    @media_item = MediaItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ["MediaItem not found"] }, status: :not_found
  end

  # Permit only metadata fields; files handled separately
  def media_item_params
    params.require(:media_item).permit(:title, :media_type, :position, :file, files: [])
  end

 def media_item_json(item)
  {
    id: item.id,
    title: item.title,
    media_type: item.media_type,
    position: item.position,
    likes_count: item.likes_count,
    user_id: item.user_id,
    url: item.file.attached? ? Rails.application.routes.url_helpers.rails_blob_url(item.file, only_path: false) : nil,
    filename: item.file.attached? ? item.file.filename.to_s : nil,
    content_type: item.file.attached? ? item.file.content_type : nil
  }
end
end
