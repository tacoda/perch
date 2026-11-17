class Lens < ApplicationRecord
  has_many :field_kit_items, dependent: :destroy
  has_many :sightings, dependent: :destroy

  attr_accessor :my_field_kit_item
end
