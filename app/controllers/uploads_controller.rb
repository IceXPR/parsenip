class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :restrict_to_api_users


  def create
    upload = Upload.new
    upload.user = @user
    upload.file = params['file']
    if upload.save
      render json: {success: 'true', upload_token: "#{upload.upload_token}"}
    end
  end

  def progress
    if params['upload_token']
      upload = @user.uploads.find_by(upload_token: params['upload_token'])
      if upload
        render json: {progress: "#{upload.percent_complete}"}
      else
        render json: {error: 'No upload matches your token and user'}
      end
    else
      render json: {error: 'Upload Token Required'}
    end

  end

end