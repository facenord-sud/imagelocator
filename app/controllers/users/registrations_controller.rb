#pour devise. Permet de rajouter des attributs personalisés et d'éviter le un permitted attributes error
class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  def update_resource(resource, params)
    tags = params[:tag_ids]
    if tags.length > 0
      tag_ids = tags.gsub(/\[/, ',').gsub(/\]/, '').split(',')
      tag_ids.collect! {|tag_id| tag_id.to_i}
      tag_ids.reject! {|tag_id| tag_id == 0}
      params[:tag_ids] = tag_ids if tag_ids.any?
    else
      params[:tag_ids] = nil
    end
    resource.update_without_password(params)
  end

  protected

  def configure_permitted_parameters
    logger.debug('called from controllers/users/registrations_controller.rb')
    devise_parameter_sanitizer.for(:sign_up).push(:name, :phone, :organization)
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation, :current_password, :tag_ids)
    end
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

end