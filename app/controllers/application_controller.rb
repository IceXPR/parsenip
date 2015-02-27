class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :signout_api_user

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
    secret_api_authenticate || public_api_authenticate
  end

  def public_api_authenticate
    if params[:api_key].present?
      api_key = ApiKey.where({key: params[:api_key]}).first
      # If it's a valid api key and they requested from the permitted url, the request is valid.
      if api_key.present? and api_key.valid_request(request)
        signin_api_user(api_key.user)
        return true
      end
    end
    false
  end

  # Attempt to authenticate with the user's secret api key.
  def secret_api_authenticate
    user = User.find_by_id(ApiAuth.access_id(request))
    if ApiAuth.authentic?(request, user.try(:secret_key))
      signin_api_user user
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

  def signin_api_user(user)
    @api_authenticated = true
    @user = user
    sign_in @user
  end

  def signout_api_user
    if @api_authenticated
      sign_out @user
    end
  end
end
