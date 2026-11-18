class FieldKitItemsController < ApplicationController
  before_action :require_signin
  before_action :set_item, only: %i[show destroy]

  def index
    item = current_user.field_kit_item_for_most_recent_sighting ||
           current_user.field_kit_items.order(:id).first

    if item
      redirect_to item
    else
      render :empty
    end
  end

  def show
    @items = current_user.field_kit_items.includes(:lens).order(:id)
    @sightings = @item.lens.sightings.where(user: current_user).includes(:lens).order(created_at: :desc)
    @sighting = Sighting.new(lens: @item.lens)
  end

  def create
    @lens = Lens.find(params[:lens_id])
    @item = current_user.field_kit_items.find_or_initialize_by(lens: @lens)

    if @item.new_record? && @item.save
      @lens.my_field_kit_item = @item
      respond_to do |format|
        format.turbo_stream { render turbo_stream: lens_kit_streams(@lens) }
        format.html { redirect_to lenses_path, notice: "Added to your field kit." }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to lenses_path, alert: "That lens is already in your field kit." }
      end
    end
  end

  def destroy
    @lens = @item.lens
    @item.destroy
    @lens.my_field_kit_item = nil

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: lens_kit_streams(@lens) + [ turbo_stream.remove(@item) ]
      end
      format.html { redirect_to lenses_path, notice: "Removed from your field kit." }
    end
  end

  private

  def set_item
    @item = current_user.field_kit_items.find(params[:id])
  end

  def lens_kit_streams(lens)
    [
      turbo_stream.replace(dom_id(lens, :kit), partial: "lenses/field_kit_button", locals: { lens: lens }),
      turbo_stream.update(dom_id(lens, :popularity), lens.reload.field_kit_items_count),
      turbo_stream.update("field_kit_items_count", current_user.field_kit_items.count)
    ]
  end
end
