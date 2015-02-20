class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token


  def create
    upload = Upload.new
    upload.file = params['file']
    if upload.save
      render json: {success: 'true', upload_token: "#{upload.upload_token}"}
    end
  end

  def progress
    upload = Upload.find_by(upload_token: params[:upload_token])
    render json: {progress: "#{upload.progress}"}
  end

end