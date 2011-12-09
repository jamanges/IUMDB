class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :release_year
      t.string :link_to_image
      t.text :description
      t.integer :length

      t.timestamps
    end
  end
end
