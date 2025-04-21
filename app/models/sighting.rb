class Sighting < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :lens
  belongs_to :user
end
