class SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    if !resource.active
      sign_out resource
      flash[:alert] = 'Your account is not active. Please contact the administrator.'
      redirect_to new_user_session_path and return
    end

    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
end
