class UserMailer < ActionMailer::Base
  default from: "<Tex-Weight-Loss> welcome@clark-travel.com"
  
  def activation_email(user)
    @user = user
    @url = activate_users_url(activation_token: @user.activation_token)
    
    mail(to: "#{user.full_name} <#{user.email}>", subject: 'Welcome to Clark-Travel')
  end
  
  def password_reset_email(user)
    @user = user
    @url = password_reset_users_url(reset_token: @user.activation_token)
    
    mail(to: "#{user.full_name} <#{user.email}>", subject: 'Clark-Travel Password Reset')
  end
end
