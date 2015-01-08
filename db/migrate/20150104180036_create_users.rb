class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.boolean :is_admin, null: false, default: false
     
      t.string :password_digest, null: false
      t.string :session_token, null: false
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.boolean :is_active, null: false, default: false
      t.string :activation_token, null: false, default: "INACTIVE"
      
      t.string :uid
      t.string :access_token
      t.string :provider
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.string :fb_image_url
      
      t.boolean :display, null: false, default: true
      t.integer :position
      t.string :title, :string
      t.text :bio
      t.string :phone
      t.string :work_phone 
      t.string :home_phone
      t.string :mobile_phone
      t.string :fax
      t.string :timezone, null: false, default: "Eastern Time (US & Canada)"
      
      t.timestamps
    end
    
    add_attachment :users, :avatar

    add_index :users, :email, unique: true
    add_index :users, :display
  end
end
