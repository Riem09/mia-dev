FactoryGirl.define do

  factory :uploaded_video do
    sequence(:title) { |n|
      "UploadedVideo title #{n}"
    }
    sequence(:description) { |n|
      "UploadedVideo description #{n}"
    }
    published true
    duration_ms 4992
    association :owner, factory: :user
    association :video_upload
  end

  factory :video, :class => Video do
    sequence(:title) { |n|
      "Ta-ku - When I Met You #{n}"
    }
    sequence(:description) { |n|
      "*100,000 - 2/8/13 thanks y'all and keep jammin...#{n}"
    }
    transcript 'Winter is dangerous enough.  Go do something about it.'
    director 'Andy McLeod'
    production 'Rattling Stick'
    fx 'Animal Makers'
    client 'Goodyear'
    industry 'Automotive'
    year '2010'
    location 'North America'
    sequence(:external_id) { |n|
      "id-#{n}"
    }
    association :owner, factory: :user
    type "Video"
    sequence(:external_url) { |n|
      "https://www.youtube.com/watch?v=id-#{n}"
    }
    thumbnail_default "https://i.ytimg.com/vi/xjsI4-hsJCw/default.jpg"
    thumbnail_medium "https://i.ytimg.com/vi/xjsI4-hsJCw/mqdefault.jpg"
    thumbnail_high "https://i.ytimg.com/vi/xjsI4-hsJCw/hqdefault.jpg"
    published true
  end

end
