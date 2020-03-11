class ScannedOut < ApplicationRecord
  belongs_to :item
  attribute :name, :string
  attribute :description, :string
  attribute :category_id, :string
  
  scope :last_created, -> { order(created_at: :asc).last(5)}
end
