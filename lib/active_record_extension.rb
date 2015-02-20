module ActiveRecordExtension

  extend ActiveSupport::Concern
  extend ActiveModel::Naming
  
  def model_name
    self.class.model_name
  end
  
  # I know this isn't that clear, but doesn't it look so good on one line?!
  
  def form_header_text
    (((persisted?) ? "New " : "Update ") + model_name.human).split.map(&:capitalize)*' '
  end
  
  def button_text
    (persisted?) ? "Create" : "Update"
  end
  
  module ClassMethods
    def generate_unique_token_for_field(field)
      begin
        token = SecureRandom.urlsafe_base64(16)
      end until !self.exists?(field => token)

      token
    end
  end
end

# ActiveRecord::Base.send(:include, ActiveModel::Naming)
ActiveRecord::Base.send(:include, ActiveRecordExtension)