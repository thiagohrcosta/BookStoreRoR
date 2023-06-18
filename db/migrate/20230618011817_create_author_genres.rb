class CreateAuthorGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :author_genres do |t|
      t.references :author, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true
      t.timestamps
    end
  end
end
