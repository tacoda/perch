class FieldKitItem < ApplicationRecord
  belongs_to :user
  belongs_to :lens, counter_cache: true
end
