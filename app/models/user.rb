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

class User < ActiveRecord::Base
  extend ActiveModel::Callbacks
  
  attr_reader :password
  
  validates_confirmation_of :password
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :session_token, presence: true, uniqueness: true
  validates :uid, uniqueness: {scope: :provider, if: :check_uid_by_provider}
  validates_format_of :work_phone, :mobile_phone, :home_phone, :fax, with: /\d/, allow_blank: true
  
  has_attached_file :avatar,
                    :styles => { :small => "160x200", :medium => "360x450>", :thumb => "100x100>" },
                    :default_url => ":style/missing.png",
                    :bucket => ENV["AWS_BUCKET"]
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  define_model_callbacks :create
  before_validation :ensure_session_token
  before_validation :set_temporary_password, on: :create
  before_create :set_activation_token
  
  has_many(
    :promotions,
    class_name: "Promotion",
    foreign_key: :user_id,
    primary_key: :id,
    inverse_of: :user
  )
  
  has_many(
    :testimonials,
    class_name: "Testimonial",
    foreign_key: :user_id,
    primary_key: :id,
    inverse_of: :user
  )
  
  has_many(
    :booking_categories,
    class_name: "BookingCategory",
    foreign_key: :user_id,
    primary_key: :id,
    inverse_of: :user
  )
  
  has_many :bookings, through: :booking_categories, source: :bookings
  
  include Imageable
  
  ### Mailer Methods ###
  
  def send_contact_me_email(params)
    UserMailer.contact_me_email(self, params).deliver   
  end
  ######################
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def full_name
    name if first_name || last_name
  end
  
  def phone_format(attr = :phone, options = {area_code: true})
    ActiveSupport::NumberHelper.number_to_phone(self.try(attr), options)
  end
  
  ### Oauth Methods ###
  
  def self.from_omniauth!(auth)
    where(auth.slice(:provider, :uid)).first.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      full_name = auth.info.name.split(" ")
      user.first_name = full_name[0]
      user.last_name = full_name[-1]
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.fb_image_url = auth.info.image
      user.save!
    end
  end
  
  def update_omniauth!(auth)
    return nil unless auth
    full_name = auth.info.name.split(" ")
    # self.oauth_token = auth.credentials.token
    self.update_attributes({
      provider: auth.provider,
      uid: auth.uid,
      first_name: full_name[0],
      last_name: full_name[-1],
      oauth_token: auth.credentials.token,
      oauth_expires_at: ((auth.credentials.expires_at) ? Time.at(auth.credentials.expires_at) : Time.now.advance(years: 9999)),
      fb_image_url: fb_picture_url
      })
  end
  
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end

  def friends_count
    facebook { |fb| fb.get_connection("me", "friends").size }
  end
  
  def valid_facebook?
    uid && provider == "facebook" && oauth_token && !oauth_expires_at.past?
  end
  
  def fb_picture_url
    facebook.get_picture("me")
  end
  
  def fb_permissions
    facebook.get_connection("me", "persmissions")
  end
  
  ### Auth Methods ###
  
  def is_admin?
    is_admin
  end
  
  def send_password_reset
    self.password_reset_token = self.class.generate_unique_token_for_field(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    
    UserMailer.password_reset_email(self).deliver    
  end
  
  def activate!
    self.update_attribute(:is_active, true)
  end
  
  def set_activation_token
    self.activation_token = self.class.generate_unique_token_for_field(:activation_token)
  end
  
  def set_activation_token!
    @token = set_activation_token
    
    save
    
    @token
  end
  
  def set_temporary_password
    self.password = self.class.generate_unique_token_for_field(:password_digest) unless self.password_digest
  end
  
  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)
    user.try(:is_password?, password) ? user : nil
  end


  def self.generate_session_token
    self.generate_unique_token_for_field(:session_token)
  end

  def is_password?(unencrypted_password)
    BCrypt::Password.new(self.password_digest).is_password?(unencrypted_password)
  end

  def password=(unencrypted_password)
    if unencrypted_password.present?
      @password = unencrypted_password
      self.password_digest = BCrypt::Password.create(unencrypted_password)
    end
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def check_uid_by_provider
    uid || provider
  end
end
