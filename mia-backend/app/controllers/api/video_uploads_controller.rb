class Api::VideoUploadsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:authorize, :callback]
  before_action :login_required, except: [:show, :callback]

  def show
    @video_upload = VideoUpload.find(params[:id])
    render json: @video_upload
  end

  def create
    @video_upload = VideoUpload.create(video_upload_params)
    if @video_upload.save
      render json: 'created', status: 201
    else
      render json: @video_upload.errors, status: 422
    end
  end

  def authorize
    payload = JSON.parse(params['payload'])
    options = {profiles: "h264,webm", file_name: payload['filename'], file_size: payload['filesize']}
    upload  = TelestreamCloud.post('/videos/upload.json', options)
    render json: {upload_url: upload['location']}
  end

  def callback

    # We should always send Telestream a 200 response, else it will keep
    # re-sending the notification, and really, it's not that important.
    #
    begin
      VideoUpload.process_callback(params)
    rescue
    end
    render json: {status: :accepted}, status: 200

  end

  protected

  def video_upload_params
    params.require(:video_upload).permit(:telestream_id)
  end

end
