# Read about factories at https://github.com/thoughtbot/factory_girl

VIDEO_FIXTURE="file://#{Rails.root.join('features','fixtures','sample_mpeg4.mp4')}"
VIDEO_FIXTURE_DURATION=4.992

FactoryGirl.define do
  factory :video_upload do
    user
    source_video VIDEO_FIXTURE
    webm_video_url "http://video.webmfiles.org/big-buck-bunny_trailer.webm"
    mp4_video_url "http://video.blendertestbuilds.de/download.blender.org/peach/trailer_480p.mov"
  end
end
