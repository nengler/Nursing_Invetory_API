class ScannedOut < ApplicationRecord
  belongs_to :item
  attribute :name, :string
  attribute :description, :string
  attribute :category_id, :string
end
