# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  url         :string(255)
#  description :text
#  ord         :integer
#  display     :boolean          default(TRUE), not null
#  created_at  :datetime
#  updated_at  :datetime
#  source_url  :string(255)
#

class Project < ActiveRecord::Base
  
  
  belongs_to(
    :user,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id,
    inverse_of: :projects
  )
  
  include Imageable
end
