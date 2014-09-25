class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable, :polymorphic => true
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
