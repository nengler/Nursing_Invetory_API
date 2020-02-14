class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :count
      t.integer :threshold
      t.string :barcode
      t.references :category

      t.timestamps
    end
  end
end
