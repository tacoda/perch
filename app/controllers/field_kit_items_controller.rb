class FieldKitItemsController < ApplicationController
  before_action :require_signin

  def index
    if item = current_user.field_kit_item_for_most_recent_sighting
      redirect_to action: :show, id: item
    else
      render :empty
    end
  end

  def show
  end
end