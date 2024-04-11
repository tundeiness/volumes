class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      # Redirect to the appropriate path for admins
      admin_dashboard_path
    elsif resource.therapist?
      # Redirect to the appropriate path for therapists
      therapist_dashboard_path
    elsif resource.client?
      # Redirect to the appropriate path for clients
      client_dashboard_path
    else
      # Default redirection for users with unknown roles
      super
    end
  end
end
