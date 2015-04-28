module Imageable
  extend ActiveSupport::Concern

  included do
    has_many :pictures, as: :imageable
    
    accepts_nested_attributes_for :pictures
  end
end
