class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token


  def create
    puts params
    upload = Upload.new
    upload.file = params['file']
    if upload.save
      render json: {success: 'true', upload_token: "#{upload.upload_token}"}
    end
  end

  def progress
    puts params
    if params['upload_token']
      upload = Upload.find_by(upload_token: params['upload_token'])
      render json: {progress: "#{upload.percent_complete}"}
    else
      render json: {error: 'Upload Token Required'}
    end

  end

end