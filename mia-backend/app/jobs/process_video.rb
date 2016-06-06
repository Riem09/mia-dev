class ProcessVideo < ActiveJob::Base
  queue_as :default

  def self.call(model)
    if model.temp_file_url.present?
      if Rails.env.production?
        ProcessVideo.perform_later model, model.temp_file_url
      else
        ProcessVideo.perform_now model, model.temp_file_url
      end
    end
  end

  def perform(*args)
    model, temp_file_url = args
    if (/^\// =~ temp_file_url.to_s) == 0
      model.video = Rails.root.join(temp_file_url).open
    else
      model.remote_video_url = temp_file_url
    end
    model.temp_file_url = nil
    model.save
  end

end
