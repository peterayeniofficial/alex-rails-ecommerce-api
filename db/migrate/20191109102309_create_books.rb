class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :subtitle
      t.string :isbn_10
      t.string :isbn_13
      t.text :description
      t.date :released_on
      t.references :publisher, foreign_key: true
      t.references :author, foreign_key: true

      t.timestamps
    end
  end
end
