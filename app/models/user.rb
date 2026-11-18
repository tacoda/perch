class User < ApplicationRecord
  has_secure_password

  has_many :field_kit_items, dependent: :destroy
  has_many :lenses, through: :field_kit_items
  has_many :sightings, dependent: :destroy

  validates :username, presence: true,
          uniqueness: { case_sensitive: false }

  def field_kit_item_for(lens)
    field_kit_items.find_by(lens_id: lens.id)
  end

  def field_kit_item_for_most_recent_sighting
    lens_id = sightings.order(created_at: :desc).pick(:lens_id)
    lens_id && field_kit_items.find_by(lens_id: lens_id)
  end
end
