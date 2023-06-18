class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, null: false, default: ''
      t.references :author, null: false, foreign_key: true
      t.text :description, null: false, default: ''
      t.string :cover_image, null: false, default: ''
      t.string :year, null: false, default: ''
      t.float :price, null: false, default: 0.0
      t.timestamps
    end
  end
end
