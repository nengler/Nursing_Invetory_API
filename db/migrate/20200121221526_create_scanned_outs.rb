class CreateScannedOuts < ActiveRecord::Migration[6.0]
  def change
    create_table :scanned_outs do |t|
      t.integer :count
      t.references :item

      t.timestamps
    end
  end
end
