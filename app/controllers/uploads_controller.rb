class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :restrict_to_api_users
  before_filter :allow_cors

  # How many lines should we sample immediately after the upload?
  UPLOAD_SAMPLING_SIZE = 3
  UPLOAD_DETECTION_AMOUNT = 10

  def upload
    upload = Upload.new
    upload.user = @user
    upload.file = params['file']
    upload.callback_url = params['callback_url']

    if upload.save
      # todo get these lines moved somewhere else
      upload.set_number_of_lines
      upload.set_number_of_columns
      matches = ColumnMatchService.new(upload).detect(UPLOAD_DETECTION_AMOUNT)
      sample  = upload.get_first_lines(UPLOAD_SAMPLING_SIZE)
      render json: {success: 'true',
                    upload_token: "#{upload.upload_token}",
                    matches: matches,
                    available_columns: Column.select([:id, :key, :name]),
                    sample: sample }
    end
  end

  def create
    upload = Upload.new
    upload.user = @user
    upload.file = params['file']
    if upload.save
      if params['return_url']
        redirect_to params['return_url'] + "?upload_token=#{upload.upload_token}"
      else
        render json: {success: 'true', upload_token: "#{upload.upload_token}"}
      end
    end
  end

  def confirm
    with_upload_token do |upload|
      if upload.assigned_columns.count > 0
        render json: {error: "Columns have already been assigned to this upload."}
      end

      column_confirmation_params.each_with_index do |column_key, index|
        upload.assigned_columns.create({
                                           column_number: index,
                                           column: Column.find_by_key(column_key)
                                       })
      end
      GatherData.perform_async(upload.id)
      render json: {success: 'true'}
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

  private
  def with_upload_token
    if params['upload_token']
      upload = @user.uploads.find_by(upload_token: params['upload_token'])
      if upload
        yield(upload)
      else
        render json: {error: 'No upload matches your token and user'}
      end
    else
      render json: {error: 'Upload Token Required'}
    end
  end

  def column_confirmation_params
    upload = params['upload']
    upload['columns']
  end

end
