class ContactMesController < ApplicationController
  
  def new
    
  end
  
  def create
    User.find_by_credentials(ENV["DEV_EMAIL"], ENV["DEV_PASSWORD"]).send_contact_me_email(permitted_params.contact_me)
    flash[:notice] = ["Message Sent!"]
    redirect_to root_url
  end
  
end
