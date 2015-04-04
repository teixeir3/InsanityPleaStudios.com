module Imageable
  extend ActiveSupport::Concern

  included do
    has_many :pictures, as: :imageable
  end
end
