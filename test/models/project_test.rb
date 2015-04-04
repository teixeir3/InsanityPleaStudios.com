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

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
