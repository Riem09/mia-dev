FactoryGirl.define do

  factory :video_motif do
    video
    motif
    association :owner, :factory => :user
    sequence(:description) { |n|
      "VideoMotifDescription #{n}"
    }
    before(:create) do |vm|
      vm.start_time_ms ||= 0
      vm.end_time_ms ||= vm.video.duration_ms
    end
  end

end