class Lens < ApplicationRecord
  has_many :sightings

  attr_accessor :my_field_kit_item
end