class LensesController < ApplicationController
  def index
    @lenses = Lens.all
  end

  def show
    @lens = Lens.find(params[:id])
  end
end