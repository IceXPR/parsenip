class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def restrict_to_api_users 
    if !api_authenticate
      render json: {success: false, error: I18n.t('errors.not_permitted')} 
    end
  end

  def authenticate_user
    if !current_user
      redirect_to new_user_session_url
    end
  end

  private

  def api_authenticate
    @user = User.find_by_id(ApiAuth.access_id(request))
    if ApiAuth.authentic?(request, @user.try(:secret_key)) 
      sign_in @user 
      return true
    else
      return false
    end
  end

  def redirect_if_not_logged_in
    unless current_user
      redirect_to new_user_session_url
    end
  end
end
