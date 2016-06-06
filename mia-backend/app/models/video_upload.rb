class VideoUpload < ActiveRecord::Base

  STATUS_SUBMITTED = 'Submitted'
  STATUS_PROGRESSING = 'Progressing'
  STATUS_CANCELED = 'Canceled'
  STATUS_ERROR = 'Error'
  STATUS_COMPLETE = 'Complete'

  has_one :video, :inverse_of => :video_upload
  has_many :transcode_jobs
  belongs_to :user

  validates :telestream_id, presence: true, format: { with: /\A[a-f0-9]{6,}\z/i }

  # after_create :process_video

  def complete?
    self.status == STATUS_COMPLETE
  end

  # Legacy alias. Please don't hate me.
  def is_complete
    complete?
  end

  def process_video

    # You probably don't want to actually run encode jobs in test mode
    #
    return if Rails.env.test?

    # Find the video in Telestream
    #
    telestream = TelestreamCloud.resources :flip
    factory = telestream.factories.find(Figaro.env.telestream_factory_id)
    video = factory.videos.find(telestream_id)

    # Queue the encoding jobs and log the IDs
    #
    h264_job = factory.encodings.create(video_id: telestream_id, profile_name: "h264.HD")
    transcode_jobs.create!(telestream_job_id: h264_job.id, profile: "h264.HD")
    webm_job = factory.encodings.create(video_id: telestream_id, profile_name: "webm.hi")
    transcode_jobs.create!(telestream_job_id: webm_job.id, profile: "webm.hi")

  end

  def check_completeness!

    # Start complete, then loop each job, setting as false if not complete
    #
    complete = true
    transcode_jobs.each do |job|
      complete = false if job.progress < 100
    end

    # Set the complete flag if appropriate
    #
    self.update_attributes(status: STATUS_COMPLETE) if complete
    return complete

  end

  def self.process_callback(params)

    # Create a new VideoUpload in the event of a creation trigger
    #
    if params[:event] == "video-created"
      video_upload = VideoUpload.create!(telestream_id: params[:video_id])

    # Update an existing VideoUpload when it's finished
    #
    elsif params[:event] == "video-encoded"
      video_upload = VideoUpload.find_by_telestream_id(params[:video_id])
      video_upload.status = STATUS_COMPLETE

    # Update a TranscodeJob when we get info about its progress
    #
    elsif params[:event] == "encoding-progress"
      transcode_job = TranscodeJob.find_by_telestream_job_id(params[:encoding_id])
      transcode_job.update_attributes(progress: params[:progress])

    # Set the TranscodeJob's status as complete when we get an encode complete
    #
    elsif params[:event] == "encoding-complete"
      transcode_job = TranscodeJob.find_by_telestream_job_id(params[:encoding_id])
      transcode_job.update_attributes(progress: 100)
    end

  end

end
