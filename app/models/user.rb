class User < ApplicationRecord
    has_secure_password

    has_many :field_kit_items, dependent: :destroy
    has_many :sightings, dependent: :destroy

    validates :username, presence: true,
            uniqueness: { case_sensitive: false }
end
