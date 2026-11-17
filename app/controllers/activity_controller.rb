class ActivityController < ApplicationController
  def index
    @sightings = Sighting.includes(:user, :lens).order(created_at: :desc).limit(50)
  end
end
