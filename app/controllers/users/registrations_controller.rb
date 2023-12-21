class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :add_second_navbar

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def after_sign_up_path_for(resource)
    users_path(resource)
  end

  def after_sign_in_path_for(resource)
    users_path(resource)
  end

  private

  def add_second_navbar
    @show_second_navbar = true
  end
end
