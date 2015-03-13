class ApiKeysController < ApplicationController
  before_filter :redirect_if_not_logged_in

  def index
  end

  def new
    @api_key = ApiKey.new
  end

  def destroy
    api_key = scope.api_keys.find_by_id(params[:id])
    if api_key and api_key.destroy
      flash[:success] = t('success.destroy', {model: ApiKey})
    else
      flash[:error] = t('errors.destroy', {model: ApiKey})
    end
    redirect_to api_keys_path
  end

  def create
    @api_key = ApiKey.new(api_key_params)
    @api_key.user = current_user
    if @api_key.save
      flash_message = t('success.create', {model: ApiKey})
      render json: {success: true, permit_url: @api_key.permit_url, api_key: @api_key.key, message: flash_message}
    else
      flash_message = @api_key.errors.full_messages.to_sentence
      render json: {success: false, permit_url: params[:api_key][:permit_url], message: flash_message}
    end
  end

  private

  def scope
    current_user
  end

  def api_key_params
    params[:api_key].permit(:permit_url)
  end
end
