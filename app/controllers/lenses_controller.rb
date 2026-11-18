class LensesController < ApplicationController
  def index
    @categories = Lens.distinct.order(:category).pluck(:category)
    @lenses = Lens.order(:name)
    @lenses = @lenses.where("name ILIKE ?", "%#{params[:query]}%") if params[:query].present?
    @lenses = @lenses.where(category: params[:category]) if params[:category].present?

    if signed_in?
      items = current_user.field_kit_items.index_by(&:lens_id)
      @lenses.each { |lens| lens.my_field_kit_item = items[lens.id] }
    end
  end

  def show
    @lens = Lens.find(params[:id])
    @lens.my_field_kit_item = current_user&.field_kit_item_for(@lens)
    @top_sightings = @lens.sightings.includes(:user).order(likes_count: :desc, created_at: :desc).limit(5)
  end
end
