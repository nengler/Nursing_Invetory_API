class Item < ApplicationRecord
  belongs_to :category
  has_many :scanned_in, dependent: :destroy
  has_many :scanned_out, dependent: :destroy

  validates :name, presence: true 
  validates :barcode_id, length: { is: 10 }
  validates :count, numericality: { greater_than_or_equal_to: 0 }
end
