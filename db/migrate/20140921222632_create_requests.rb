class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :user
      t.string :title
      t.string :description
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
