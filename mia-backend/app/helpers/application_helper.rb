module ApplicationHelper
  def new_temp_upload
    upload = TempUpload.new
    upload.upload.success_action_redirect = temp_upload_redirect_hook_url
    upload
  end

  def new_video
    vid = Video.new
    vid.video_upload = VideoUpload.new
    vid
  end

end
