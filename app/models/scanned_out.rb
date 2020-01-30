class ScannedOut < ApplicationRecord
  belongs_to :item
  attribute :name, :string
  attribute :description, :string
end
