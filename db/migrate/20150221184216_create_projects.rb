class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :url
      t.text :description
      t.integer :ord
      t.boolean :display, null: false, default: true
 
      t.timestamps
    end
  end
end
