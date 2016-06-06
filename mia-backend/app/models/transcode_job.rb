class TranscodeJob < ActiveRecord::Base

  belongs_to :video_upload

  validates :video_upload, presence: true
  validates :telestream_job_id, presence: true, format: { with: /\A[a-f0-9]{6,}\z/i }
  validates :progress, numericality: { only_integer: true }
  validates :profile, presence: true

  before_validation do
    self.progress = 0 if self.progress.nil?
  end

  after_save do
    video_upload.check_completeness! if self.progress == 100
  end

end
