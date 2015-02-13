class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token


  def create
    upload = Upload.new
    upload.file = params['file']
    if upload.save
      render json: {success: 'true', upload_token: "#{upload.upload_token}"}
    end
  end

end