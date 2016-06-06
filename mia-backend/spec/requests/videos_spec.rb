require 'rails_helper'

describe 'Videos' do

  include Requests::Auth

  before(:each) do
    @user = create(:user)
    sign_in @user
  end

  describe 'POST /videos' do

    it 'should accept a valid POST' do

      expect(Video).to receive(:retrieve_youtube_data).and_return({
                                                                      :title => 'Old Spice Pro-Strength Commercial - Neil Patrick Harris',
                                                                      :description => 'Another new commercial for Old Spice with Neil Patrick Harris.',
                                                                      :thumbnail_default => 'default.jpg',
                                                                      :thumbnail_medium => 'mqdefault.jpg',
                                                                      :thumbnail_high => 'hqdefault.jpg',
                                                                      :duration_ms => 42
                                                                  })

      post api_videos_path, {
          :video => {
              :external_url => 'http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrec_grec_index'
          }
      }

      video = assigns(:video)

      expect(video).to_not be_nil
      expect(video).to be_valid
      expect(video.errors.empty? ).to eq(true)
      expect(video.title).to eq('Old Spice Pro-Strength Commercial - Neil Patrick Harris')
      expect(video.description).to eq('Another new commercial for Old Spice with Neil Patrick Harris.')
      expect(video.thumbnail_default).to include('default.jpg')
      expect(video.thumbnail_medium).to include('mqdefault.jpg')
      expect(video.thumbnail_high).to include('hqdefault.jpg')
      expect(video.duration_ms).to eq(42)

    end

    it 'should not accept an invalid POST' do

      post api_videos_path, {
          :video => {
              :external_url => 'htasl;dfiea'
          }
      }
      video = assigns(:video)

      expect( video.errors.empty? ).to eq(false)

    end

  end

  describe 'GET index' do

    it 'Should order the videos in order of newest to oldest' do
      videos = create_list(:video, 10, :published => false)
      get api_videos_path, {
          :published => false,
          format: :json
      }
      at_videos = assigns(:videos)
      expect( at_videos.to_a ).to eq( videos.reverse )
    end

    it 'Should only show published videos' do

      unpublished = create_list(:video, 2, :published => false)
      get api_videos_path, {
          :published => false,
          format: :json
      }
      expect( assigns(:videos).count ).to eq(2)

      published = create_list(:video, 3, :published => true)
      get api_videos_path, {
          :published => false,
          :format => :json
      }
      expect( assigns(:videos).count ).to eq(2)

      get api_videos_path, {
          :published => true,
          :format => :json
      }
      expect( assigns(:videos).count).to eq(3)

    end

  end

  describe 'GET show' do


    it 'Should include the video motifs for a video' do

    end

  end

  describe 'PUT update' do

    it 'Should allow the owner to edit the title and description' do

      video = create(:video, :owner => @user)

      put api_video_path(video), {
          :id => video.id,
          :format => :json,
          :video => {
              :id => video.id,
              :title => 'NewTitle',
              :description => 'NewDescription'
          }
      }

      expect(response.status).to eq(200)
      video = Video.find(video.id)
      expect(video.title).to eq('NewTitle')
      expect(video.description).to eq('NewDescription')

    end

  end



end