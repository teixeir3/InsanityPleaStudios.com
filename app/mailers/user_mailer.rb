class UserMailer < ActionMailer::Base
  default from: "noreply <info@insanitypleastudios.com>"

  def activation_email(user)
    @user = user
    @url = activate_users_url(activation_token: @user.activation_token)
  
    mail(to: "#{user.full_name} <#{user.email}>", subject: 'Hello from InsanityPleaStudios.com')
  end

  def password_reset_email(user)
    @user = user
    @url = password_reset_users_url(reset_token: @user.activation_token)
  
    mail(to: "#{user.full_name} <#{user.email}>", subject: 'InsanityPleaStudios.com Password Reset')
  end
  
  def contact_me_email(user, params)
    @user = user
    @params = params
    
    mail(to: "#{user.full_name} <#{user.email}>", subject: 'InsanityPleaStudios.com Inquiry')
  end
  
end
