require 'rails_helper'

describe Api::VideosController do

  before(:each) do
    @u = create(:user)
  end

  let(:video_params) do
    {
        :title => "Fake Title",
        :external_id => nil,
        :external_url => "https://www.youtube.com/watch?v=52349522",
        :thumbnail_default => "https://i.ytimg.com/vi/xjsI4-hsJCw/default.jpg",
        :thumbnail_medium => "https://i.ytimg.com/vi/xjsI4-hsJCw/mqdefault.jpg",
        :thumbnail_high => "https://i.ytimg.com/vi/xjsI4-hsJCw/hqdefault.jpg"
    }
  end

  describe 'create' do

    it 'should not allow anonymous video creation' do
      post :create, { :video => video_params }
      expect(response).to redirect_to(new_user_session_path)
      expect(Video.find_by_external_url(video_params()[:external_url])).to be_nil
    end

    it 'should allow logged in users to create videos' do
      params = video_params
      sign_in(@u)
      post :create, { :video => params }
      vid = Video.find_by_external_url(params[:external_url])
      expect(vid).to_not be_nil
      expect(vid.owner).to eq(@u)
    end

    it 'should allow a user to upload a video' do
      vu = create(:video_upload)
      sign_in(@u)
      post :create, { :video => {
          :title => 'Foobar',
          :video_upload_attributes => {
              :source_video => vu.source_video
          }
      }}
      v = assigns(:video)
      expect(v).to be_valid
    end

    it 'should detect whether a video already exists' do
      original = Video.create(video_params.merge({:owner => @u}))
      expect(original).to be_valid
      expect(original.errors).to be_empty
      sign_in(@u)
      post :create, { :format => :json, :video => video_params }
      expect(response.status).to eq(422)
      expect(assigns(:video)).to_not be_nil
      expect(assigns(:video).duplicate_video).to eq( Video.find(original.id) )
    end

  end

  def valid_update_attributes(opts = {})
    {
        :id => @vid.id,
        :video => {
            :title => "Foobar"
        }
    }.merge(opts)
  end

  before(:each) do
    @m1 = create(:motif)
    @m2 = create(:motif, :parent => @m1)
    @m3 = create(:motif)
    @vid = create(:video, :published => false)
    @vm2 = create(:video_motif, :video => @vid, :motif => @m2, :start_time_ms => 1000, :end_time_ms => 2000)
    @vm3 = create(:video_motif, :video => @vid, :motif => @m3, :start_time_ms => 1000, :end_time_ms => 2000)
    @vid2 = create(:video, :published => false)
    @vm4 = create(:video_motif, :video => @vid2, :motif => @m3)
    @vid3 = create(:video, :published => true)
  end

  describe 'update' do

    it 'should not allow anonymous users to update videos' do
      put :update, valid_update_attributes
      expect(response.status).to redirect_to( new_user_session_path )
    end

    it 'should allow a logged in user to update the video' do
      sign_in @vid.owner
      put :update, valid_update_attributes
      expect(Video.find(@vid.id).title).to eq("Foobar")
    end

  end

  describe 'index' do

    it 'should show published videos if no query params passed' do

      get :index

      expect(assigns(:videos)).to include(@vid3)
      expect(assigns(:videos)).to_not include(@vid1)


    end

    it 'should show unpublished videos if unpublished query passed' do

      get :index, {
          :published => false
      }

      expect(assigns(:videos)).to include(@vid)
      expect(assigns(:videos)).to include(@vid2)
      expect(assigns(:videos)).to_not include(@vid3)
    end

    it 'should show only videos that have a motif if a single motifs is passed' do
      get :index, {
          :published => false,
          :motif_ids => [
              @m2.id
          ]
      }
      expect(assigns(:videos)).to include(@vid)
      expect(assigns(:videos)).to_not include(@vid2)
    end

    it 'QUERY STYLE should show only videos that have a motif a single motifs is passed' do
      get :index, {
          :published => false,
          :query => [
              "__#{@m2.id}"
          ]
      }
      expect(assigns(:videos)).to include(@vid)
      expect(assigns(:videos)).to_not include(@vid2)
    end

    it 'should show only the videos that have a motif whose ancestor is passed' do
      get :index, {
          :published => false,
          :motif_ids => [
              @m2.id
          ]
      }
      expect(assigns(:videos)).to include(@vid)
      expect(assigns(:videos)).to_not include(@vid2)

    end

    it 'should show only videos that have *all* of the passed motifs' do
      get :index, {
          :motif_ids => [
              @m2.id, @m3.id
          ],
          :page => 1,
          :published => false
      }
      expect(assigns(:videos)).to include(@vid)
      expect(assigns(:videos)).to_not include(@vid2)
    end

    it 'QUERY STYLE should show only videos that have *all* of the passed motifs' do
      get :index, {
          :query => [
              "__#{@m2.id}",
              "__#{@m3.id}"
          ],
          :page => 1,
          :published => false
      }
      expect(assigns(:videos)).to include(@vid)
      expect(assigns(:videos)).to_not include(@vid2)
    end

    it 'should allow the user to search using keywords' do

      fb = create(:video, :title => 'foobar', :published => false)

      get :index, {
          :published => false,
          :keywords => [
              'foobar'
          ]
      }

      expect(assigns(:videos)).to include(fb)
      expect(assigns(:videos)).to_not include(@vid)

    end

    it 'should allow the user to search by keyword and motif' do

      fb1 = create(:video, :title => 'foobar', :published => false)
      fb2 = create(:video, :title => 'foobar', :published => false)

      vm = create(:video_motif, :video => fb2)

      get :index, {
          :published => false,
          :keywords => [
              'foo'
          ],
          :motif_ids => [
            vm.motif.id
          ]
      }

      expect(assigns(:videos)).to include(fb2)
      expect(assigns(:videos)).to_not include(fb1)

    end

    it 'should highlight the motifs that match the search params' do

      v1 = create(:video, :description => "foo bar")
      v2 = create(:video)
      create(:video_motif, :video => v2, :motif => create(:motif, :name => 'foo'))

      get :index, {
          :keywords => [
              'foo'
          ]
      }

    end

    it 'should highlight the descriptions that match the search params' do

    end

  end

end