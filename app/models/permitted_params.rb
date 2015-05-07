class PermittedParams < Struct.new(:params, :current_user)
  def user
    
    # Format Phone numbers:
    @user_params || params.require(:user).each do |key, value|
      if key =~ /(.+)_phone$/ || key == "fax"
        params[:user][key] = value.gsub(/\D/, '')
      end
    end

    @user_params ||= params.require(:user).permit(user_attributes)
  end
  
  def user_attributes
    if current_user && current_user.is_admin?
      @user_attributes ||= [:avatar, :first_name, :last_name, :email,
        :home_phone, :work_phone, :mobile_phone,
        :fax, :bio, :position, :title, :is_admin]
    else
      @user_attributes ||= [:avatar, :first_name, :last_name, :email,
        :home_phone, :work_phone, :mobile_phone,
        :fax, :bio, :position, :title]
    end
    
    @user_attributes.delete(:email) if params[:email_confirmation] && params.require(:user)[:email] != params[:email_confirmation]
    
    @user_attributes
  end
  
  # def download
#     @download_params ||= params.require(:download).permit(download_attributes)
#   end
#
#   def download_attributes
#     @download_attributes ||= [:title, :position, :display, :user]
#   end
  
  def picture
    @picture_params ||= params.require(:picture).permit(picture_attributes)
  end
  
  def picture_attributes
    @picture_attributes ||= [:title, :position, :display, :image]
  end
  
  def project
    @project_params ||= params.require(:project).permit(project_attributes)
  end
  
  def project_attributes
    @project_attributes ||= [:title, :url, :description, :ord, :display, :source_url, :pictures_attributes, :pictures, :picture]
  end
  
  
  # Not backed up by a model.
  # TODO: Make a form model for contact_me form
  def contact_me
    @contact_me_params ||= params.require(:contact_me).permit(contact_me_attributes)
  end
  
  def contact_me_attributes
    @contact_me_attributes ||= [:name, :phone, :email, :inquiry]
  end
  
end