class Item < ApplicationRecord
  belongs_to :category

  validates :barcode_id, length: { is: 10 }
  validates :count, numericality: { greater_than_or_equal_to: 0 }
end
