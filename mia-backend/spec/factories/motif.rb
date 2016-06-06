FactoryGirl.define do

  factory :motif do
    sequence(:name) do |n|
      "MotifName#{n}"
    end
    sequence(:description) { |n|
      "MotifDescription#{n}"
    }
    association :owner, :factory => :user
    image {
      File.open( Rails.root.join('features', 'fixtures', 'camera.png') )
    }
    video_upload
    icon nil
    parent nil

  end

end