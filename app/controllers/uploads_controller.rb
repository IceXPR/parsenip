class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :restrict_to_api_users
  before_filter :allow_cors

  # Eventually we can implement XHR file uploads: http://stackoverflow.com/questions/2320069/jquery-ajax-file-upload

  def upload
    upload = Upload.new
    upload.user = @user
    upload.file = params['file']
    upload.callback_url = params['callback_url']
    if upload.save
      ParseFile.perform_async(upload.id)
      render json: {success: 'true', upload_token: "#{upload.upload_token}"}
    end
  end

  def create
    upload = Upload.new
    upload.user = @user
    upload.file = params['file']
    if upload.save
      ParseFile.perform_async(upload.id)
      if params['return_url']
        redirect_to params['return_url'] + "?upload_token=#{upload.upload_token}"
      else
        render json: {success: 'true', upload_token: "#{upload.upload_token}"}
      end
    end
  end

  def progress
    if params['upload_token']
      upload = @user.uploads.find_by(upload_token: params['upload_token'])
      if upload
        render json: {progress: upload.progress, complete: upload.complete}
      else
        render json: {error: 'No upload matches your token and user'}
      end
    else
      render json: {error: 'Upload Token Required'}
    end
  end

  def data
    if params['upload_token']
      upload = @user.uploads.find_by(upload_token: params['upload_token'])
      if upload
        render json: upload.parse_data, only: [:first_name, :last_name, :email, :phone]
      else
        render json: {error: 'No upload matches your token and user'}
      end
    else
      render json: {error: 'Upload Token Required'}
    end
  end

end
