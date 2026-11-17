class Sighting < ApplicationRecord
  include ActionView::RecordIdentifier
  include Turbo::Streams::Broadcasts

  belongs_to :lens
  belongs_to :user

  validates :species, presence: true
  validates :weight, :length, numericality: { greater_than: 0 }, allow_nil: true
end
