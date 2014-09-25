class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :user
      t.references :request
      t.string :description
      t.string :imageurl

      t.timestamps
    end
  end
end
