class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :handle_invalid_request

  def handle_invalid_request
    if request.xhr? && !api_authenticate
      render json: {success: false, error: I18n.t('errors.not_permitted')} 
    end
  end

  def restrict_to_xhr
    if !request.xhr?
      raise "Forbidden" 
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
end
