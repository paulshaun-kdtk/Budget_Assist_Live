class Users::SessionsController < Devise::SessionsController
  before_action :add_second_navbar, only: %i[new create]

  private

  def add_second_navbar
    @show_second_navbar = true
  end

  def after_sign_in_path_for(resource)
    users_path(resource)
  end
end
