class ScannedIn < ApplicationRecord
  belongs_to :item
  
  scope :last_created, -> { order(created_at: :asc).last(5)}
end
