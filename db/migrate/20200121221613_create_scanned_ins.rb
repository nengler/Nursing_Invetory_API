class CreateScannedIns < ActiveRecord::Migration[6.0]
  def change
    create_table :scanned_ins do |t|
      t.integer :count
      t.references :item

      t.timestamps
    end
  end
end
