class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :title
      t.integer :position
      t.boolean :display, null: false, default: true
      
      t.references :imageable, polymorphic: true, index: true
      
      t.timestamps
    end
    
    add_index :pictures, :imageable_type
  end
end
