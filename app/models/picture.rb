# == Schema Information
#
# Table name: pictures
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  imageable_id   :integer
#  imageable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Picture < ActiveRecord::Base
end
