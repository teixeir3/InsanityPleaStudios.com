# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  first_name             :string(255)
#  last_name              :string(255)
#  is_admin               :boolean          default(FALSE), not null
#  password_digest        :string(255)      not null
#  session_token          :string(255)      not null
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  is_active              :boolean          default(FALSE), not null
#  activation_token       :string(255)      default("INACTIVE"), not null
#  uid                    :string(255)
#  access_token           :string(255)
#  provider               :string(255)
#  oauth_token            :string(255)
#  oauth_expires_at       :datetime
#  fb_image_url           :string(255)
#  display                :boolean          default(TRUE), not null
#  position               :integer
#  title                  :string(255)
#  string                 :string(255)
#  bio                    :text
#  phone                  :string(255)
#  work_phone             :string(255)
#  home_phone             :string(255)
#  mobile_phone           :string(255)
#  fax                    :string(255)
#  timezone               :string(255)      default("Eastern Time (US & Canada)"), not null
#  created_at             :datetime
#  updated_at             :datetime
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
