class SightingsController < ApplicationController
  before_action :require_signin
  before_action :set_sighting, only: %i[show edit update destroy like]
  before_action :require_owner, only: %i[edit update destroy]
  before_action :set_lenses, only: %i[new create edit update]

  def index
    @lenses = current_user.lenses.order(:name)
    @sightings = current_user.sightings.includes(:lens).order(created_at: :desc)
    @sightings = @sightings.where(lens_id: params[:lens_id]) if params[:lens_id].present?
  end

  def show
  end

  def new
    @sighting = current_user.sightings.build(lens_id: params[:lens_id])
  end

  def create
    @sighting = current_user.sightings.build(sighting_params)
    @item = current_user.field_kit_items.find_by(id: params[:field_kit_item_id])

    respond_to do |format|
      if @sighting.save
        @sighting.broadcast_prepend_to "activity", target: "sightings",
                                        partial: "activity/sighting", locals: { sighting: @sighting }

        format.turbo_stream do
          if @item
            render turbo_stream: [
              turbo_stream.prepend(dom_id(@item, :sightings), partial: "sightings/sighting", locals: { sighting: @sighting, item: @item }),
              turbo_stream.replace("new_sighting", partial: "field_kit_items/sighting_form", locals: { item: @item, sighting: Sighting.new(lens: @item.lens) }),
              turbo_stream.replace(dom_id(@item, :stats), partial: "field_kit_items/stats", locals: { item: @item })
            ]
          else
            redirect_to sightings_path, notice: "Sighting logged."
          end
        end
        format.html { redirect_to(@item || sightings_path, notice: "Sighting logged.") }
      else
        format.turbo_stream do
          if @item
            render turbo_stream: turbo_stream.replace("new_sighting", partial: "field_kit_items/sighting_form", locals: { item: @item, sighting: @sighting }),
                   status: :unprocessable_entity
          else
            render :new, status: :unprocessable_entity
          end
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @sighting.update(sighting_params)
        @sighting.broadcast_replace_to "activity", target: dom_id(@sighting),
                                        partial: "activity/sighting", locals: { sighting: @sighting }

        format.turbo_stream do
          if turbo_frame_request?
            render turbo_stream: turbo_stream.replace(@sighting, partial: "sightings/sighting", locals: { sighting: @sighting })
          else
            redirect_to @sighting, notice: "Sighting updated."
          end
        end
        format.html { redirect_to @sighting, notice: "Sighting updated." }
      else
        format.turbo_stream do
          if turbo_frame_request?
            render turbo_stream: turbo_stream.replace(@sighting, partial: "sightings/edit", locals: { sighting: @sighting, lenses: @lenses }),
                   status: :unprocessable_entity
          else
            render :edit, status: :unprocessable_entity
          end
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = current_user.field_kit_items.find_by(id: params[:field_kit_item_id])
    @sighting.destroy
    @sighting.broadcast_remove_to "activity", target: dom_id(@sighting)

    respond_to do |format|
      format.turbo_stream do
        streams = [turbo_stream.remove(@sighting)]
        if @item
          streams << turbo_stream.replace(dom_id(@item, :stats), partial: "field_kit_items/stats", locals: { item: @item })
        end
        render turbo_stream: streams
      end
      format.html { redirect_to sightings_path, notice: "Sighting deleted." }
    end
  end

  def like
    @sighting.increment!(:likes_count)
    @sighting.broadcast_replace_to "activity", target: dom_id(@sighting, :like),
                                    partial: "sightings/like", locals: { sighting: @sighting }

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@sighting, :like), partial: "sightings/like", locals: { sighting: @sighting })
      end
      format.html { redirect_to activity_path }
    end
  end

  private

  def set_sighting
    @sighting = Sighting.includes(:lens, :user).find(params[:id])
  end

  def set_lenses
    @lenses = current_user.lenses.order(:name)
  end

  def require_owner
    redirect_to sightings_path, alert: "You can only change your own sightings." unless current_user?(@sighting.user)
  end

  def sighting_params
    params.require(:sighting).permit(:species, :weight, :length, :lens_id)
  end
end
