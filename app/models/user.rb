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
  attr_reader :password

  validates :email, presence: true, uniqueness: true
  validates :password_digest, :timezone, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :session_token, presence: true, uniqueness: true
  validates :uid, uniqueness: {scope: :provider, if: :check_uid_by_provider}
  validates_inclusion_of :timezone, in: ActiveSupport::TimeZone.zones_map(&:name)

  paginates_per 10

  before_validation :ensure_session_token
  before_create :set_activation_token
  
  # has_attached_file :avatar, :styles => {
#          :big => "600x600>",
#          :small => "100x100>"
#        },
#        :default_url => "/assets/small/missing.png"
#
#   validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  include PgSearch
  pg_search_scope :search_on_name,
                  against: [:first_name, :last_name],
                  using: {
                    :trigram => {
                      :threshold => 0.03
                    }
                  }


  ####### Start Associations #######

  has_many(
    :reminders,
    class_name: "Reminder",
    foreign_key: :patient_id,
    primary_key: :id,
    inverse_of: :patient
  )

  has_many(
    :pictures,
    as: :imageable,
    dependent: :destroy
  )
  
  ####### End Associations #######
  
  

  def full_name
    return "#{self.first_name} #{self.last_name}"
  end

  def doctor_full_name
    # Should create a 'title column'
    return "Dr. #{self.first_name} #{self.last_name}"
  end

  def full_name_by_last
    return "#{self.last_name}, #{self.first_name}"
  end

  ####### Start Auth Methods #######
  
  def send_password_reset
    self.password_reset_token = self.class.generate_unique_token_for_field(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    
    UserMailer.password_reset_email(self).deliver    
  end
  
  # Sets active attribute to true
  def activate!
    self.update_attribute(:active, true)
  end
  
  def set_activation_token
    self.activation_token = self.class.generate_unique_token_for_field(:activation_token)
  end
  
  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
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
  
  ####### End Auth Methods #######
end
