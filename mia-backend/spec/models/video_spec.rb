require 'rails_helper'

describe Video do


  describe 'url_is_youtube_or_vimeo validator' do

    it 'should complain when the url is blank' do
      expect( Video.create.valid? ).to eq(false)
    end

    it 'should complain when the url is invalid' do
      expect( Video.create(:external_url => 'asdlfk').valid? ).to eq(false)
    end

    it 'Should complain when the vimeo url is wrong' do
      expect( Video.parse_vimeo_external_id('http://vimeo.com') ).to be_nil
    end

    it 'should complain whe the youtube url is wrong' do
      expect( Video.parse_youtube_external_id('http://youtube.com') ).to be_nil
    end

    it 'url_is_youtube_or_vimeo' do
      video = Video.new
      video.external_url = 'http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrec_grec_index'
      video.is_valid_external_url
      expect(video.external_id).to eq('0zM3nApSvMg')
      expect(video.type).to eq('YouTubeVideo')
    end

    it 'should accept a vimeo URL' do
      video = Video.new
      video.external_url = 'http://vimeo.com/234234'
      video.is_valid_external_url
      expect(video.external_id).to eq('234234')
      expect(video.type).to eq('VimeoVideo')
    end

    it 'should accept a video upload' do
      user = create(:user)
      video = Video.create({
          :video_upload_attributes => {
              :source_video => Rails.root.join('features', 'fixtures', 'sample_mpeg4.mp4')
          },
          :title => 'Foobar',
          :description => 'This is Foobar',
          :owner => user
                         })
      expect(video).to be_valid

    end

  end

  describe 'vimeo_url?' do

    it 'Should correctly identify a vimeo video' do
      expect( Video.vimeo_url?('http://vimeo.com') ).to eq(true)
      expect( Video.vimeo_url?('http://www.vimeo.com')).to eq(true)
      expect( Video.vimeo_url?('https://vimeo.com/alsdkfjasdl/sf/asfd/fasd23/f:2k3l')).to eq(true)
      expect( Video.vimeo_url?('https://www.vimeo.com/')).to eq(true)
    end

  end

  describe 'youtube_url?' do

    it 'Should correctly identify youtube videos' do

      expect( Video.youtube_url?('http://youtu.be/')).to be(true)
      expect( Video.youtube_url?('http://youtu.be/asldkf')).to be(true)
      expect( Video.youtube_url?('http://youtube.com/alsdfkja')).to be(true)

    end

  end

  describe 'parse_vimeo_external_id' do
    it 'Should correctly parse a variety of urls' do
      expect( Video.parse_vimeo_external_id('http://vimeo.com/channels/staffpicks/103240599') ).to eq('103240599')
      expect( Video.parse_vimeo_external_id('http://vimeo.com/103266746') ).to eq('103266746')
      expect( Video.parse_vimeo_external_id('http://vimeo.com/couchmode/channels/927/sort:preset/103425574') ).to eq('103425574')
    end

  end


  describe 'parse_youtube_external_id' do
    it 'Should correctly parse a variety of URLs' do
      expect( Video.parse_youtube_external_id('http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrec_grec_index')).to eq('0zM3nApSvMg')
      expect( Video.parse_youtube_external_id('http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/QdK8U-VIH_o')).to eq('QdK8U-VIH_o')
      expect( Video.parse_youtube_external_id('http://www.youtube.com/v/0zM3nApSvMg?fs=1&amp;hl=en_US&amp;rel=0')).to eq('0zM3nApSvMg')
      expect( Video.parse_youtube_external_id('http://www.youtube.com/watch?v=0zM3nApSvMg#t=0m10s')).to eq('0zM3nApSvMg')
      expect( Video.parse_youtube_external_id('http://www.youtube.com/embed/0zM3nApSvMg?rel=0')).to eq('0zM3nApSvMg')
      expect( Video.parse_youtube_external_id('http://www.youtube.com/watch?v=0zM3nApSvMg')).to eq('0zM3nApSvMg')
      expect( Video.parse_youtube_external_id('http://www.youtube.com/watch?v=0zM3nApSvMg')).to eq('0zM3nApSvMg')
      expect( Video.parse_youtube_external_id('http://youtu.be/0zM3nApSvMg')).to eq('0zM3nApSvMg')
    end

  end

  describe 'retrieve_youtube_data' do

    it 'Should correctly retrieve the youtube data' do

      skip "Update of google API key restrictions"

      data = Video.retrieve_youtube_data('0zM3nApSvMg')

      expect(data[:title]).to eq('Old Spice Pro-Strength Commercial - Neil Patrick Harris')
      expect(data[:description]).to eq('Another new commercial for Old Spice with Neil Patrick Harris.')
      expect(data[:thumbnail_default]).to include('default.jpg')
      expect(data[:thumbnail_medium]).to include('mqdefault.jpg')
      expect(data[:thumbnail_high]).to include('hqdefault.jpg')
      expect(data[:duration]).to eq(16)

    end

  end

  describe 'retrieve_vimeo_data' do

    it 'should work' do

      data = Video.retrieve_vimeo_data('103266746')

      expect(data[:title]).to eq('Portugal Hyperlapse/Timelapse (Lisbon & Sesimbra)')
      expect(data[:description]).to include('Timelapse & Edit by Kirill Neiezhmakov')
      expect(data[:thumbnail_default]).to include('100x75.jpg')
      expect(data[:thumbnail_medium]).to include('200x150.jpg')
      expect(data[:thumbnail_high]).to include('640.jpg')
      expect(data[:duration_ms]).to eq(198)

    end


  end

  describe 'parseDuration' do

    it 'Should correctly parse a youtube duration code' do

      expect(Video.parseDuration('PT5M12S')).to eq(5*60+12)
      expect(Video.parseDuration('PT0M12S')).to eq(12)
      expect(Video.parseDuration('PT12S')).to eq(12)
      expect(Video.parseDuration('PT0S')).to eq(0)
      expect(Video.parseDuration('PT')).to eq(0)

    end

  end

  describe 'motifs_include' do

    before(:each) do
      @m1 = create(:motif)
      @m2 = create(:motif, :parent => @m1)
      @m3 = create(:motif)

      #has just @m2
      @v1 = create(:video)
      @vm1 = create(:video_motif, :motif => @m2, :video => @v1)
      @vm1 = create(:video_motif, :motif => @m3, :video => @v1)

      @v2 = create(:video)
      @vm2 = create(:video_motif, :motif => @m3, :video => @v2)

    end

    it 'should return videos whose motifs include the exact motif' do
      pending "Rework of search functionality"
      result = Video.motifs_include(@m2.id).to_a
      expect( result ).to include( Video.find(@v1.id) )
      expect( result.length ).to eq(1)
    end

    it 'should return videos whose motifs are descendents of the motif' do
      pending "Rework of search functionality"
      result = Video.motifs_include(@m1.id).to_a
      expect( result ).to include( Video.find(@v1.id) )
      expect( result.length ).to eq(1)
    end

    it 'should return Videos that include *all* of the motif ids passed' do

      result = Video.motifs_include_all([@m1.id,@m3.id]).to_a
      expect( result ).to include( Video.find(@v1.id) )
      expect( result ).to_not include( Video.find(@v2.id) )

    end

  end

  describe 'keywords_include' do

    before(:each) do
      @foo = create(:video, :title => 'Video foo')
      @bar = create(:video, :title => 'Video bar')
      @foobar = create(:video, :title => 'Video foo bar')
    end

    it 'should return videos whose title or descriptions include the keywords' do

      videos = Video.keywords_include(['foo']).to_a
      expect(videos).to include(@foo)
      expect(videos).to include(@foobar)
      expect(videos).to_not include(@bar)

    end

    it 'should return videos whose title or description include all keywords' do

      videos = Video.keywords_include(['foo','bar'])
      expect(videos).to include(@foobar)
      expect(videos).to_not include(@foo)
      expect(videos).to_not include(@bar)

    end

  end


  describe '#has_combined_motifs' do

    let(:m1_parent) {
      create(:motif)
    }

    let(:m1) {
      create(:motif, :parent => m1_parent)
    }
    let(:m2) {
      create(:motif)
    }
    let(:m3) {
      create(:motif)
    }

    let(:video1) {
      create(:uploaded_video)
    }

    let(:v1_vm1) {
      create(:video_motif, :video => video1, :motif => m1, :start_time_ms => 0, :end_time_ms => 1000)
    }

    let(:v1_vm2) {
      create(:video_motif, :video => video1, :motif => m2, :start_time_ms => 500, :end_time_ms => 1500)
    }

    let(:v1_vm3) {
      create(:video_motif, :video => video1, :motif => m3, :start_time_ms => 1100, :end_time_ms => 1200)
    }

    let(:video2) {
      create(:uploaded_video)
    }

    let(:v2_vm1) {
      create(:video_motif, :video => video2, :motif => m1, :start_time_ms => 0, :end_time_ms => 1000)
    }

    let(:v2_vm2) {
      create(:video_motif, :video => video2, :motif => m2, :start_time_ms => 600, :end_time_ms => 1500)
    }

    let(:search) {
      []
    }

    subject {
      v1_vm1
      v1_vm2
      v1_vm3
      v2_vm1
      v2_vm2
      Video.has_combined_motifs(search)
    }

    context 'empty motif array' do
      it 'should return videos that have overlapping motifs' do
        vids = subject
        expect(vids).to include(video1)
        expect(vids).to include(video2)
      end
    end

    context 'one motif' do
      let(:search) { [m1.id] }

      it 'should return all videos that include the motif' do
        vids = subject
        expect(vids).to include(video1)
        expect(vids).to include(video2)
      end

      it '#get_combined_motif_vm_ids' do
        vids = subject
        expect(vids.first.get_combined_motif_vm_ids).to eq([v1_vm1.id])
        expect(vids.last.get_combined_motif_vm_ids).to eq([v2_vm1.id])
      end

      describe '#combined_start_time' do
        it 'should return the motifs start time ms' do
          vids = subject
          expect(vids.first.combined_start_time).to eq(v1_vm1.start_time_ms)
          expect(vids.last.combined_start_time).to eq(v2_vm1.start_time_ms)
        end
      end
      describe '#combined_end_time' do
        it 'should return the motifs end time' do
          vids = subject
          expect(vids.first.combined_end_time).to eq(v1_vm1.end_time_ms)
          expect(vids.last.combined_end_time).to eq(v2_vm1.end_time_ms)
        end
      end

    end

    context 'two motifs' do
      let(:search) { [m1.id, m2.id] }
      it 'should return all the videos' do
        vids = subject
        expect(vids).to include(video1)
        expect(vids).to include(video2)
      end
      it '#get_combined_motif_vm_ids' do
        vids = subject
        expect(vids.first.get_combined_motif_vm_ids).to eq([v1_vm1.id, v1_vm2.id])
        expect(vids.last.get_combined_motif_vm_ids).to eq([v2_vm1.id, v2_vm2.id])
      end
      it '#combined_start_time' do
        vids = subject
        expect(vids.first.combined_start_time).to eq(v1_vm2.start_time_ms)
        expect(vids.last.combined_start_time).to eq(v2_vm2.start_time_ms)
      end
      it '#combined_end_time' do
        vids = subject
        expect(vids.first.combined_end_time).to eq(v1_vm1.end_time_ms)
        expect(vids.last.combined_end_time).to eq(v2_vm1.end_time_ms)
      end
    end

    context 'last match doesnt overlap the first' do
      let(:search) { [m1.id, m2.id, m3.id] }
      it 'should not match anything' do
        expect(subject).to be_empty
      end
      it '#get_combined_motif_vm_ids' do
        expect(video1.get_combined_motif_vm_ids).to be_empty
      end
      it '#combined_start_time' do
        expect(video1.combined_start_time).to be_nil
      end
      it '#combined_end_time' do
        expect(video1.combined_end_time).to be_nil
      end
    end

    context 'must allow users to search with parents as well' do

      let(:search) { [m1_parent.id, m2.id] }
      it 'should return all the videos' do
        pending "The hierarchical implementation of the search function"
        vids = subject
        expect(vids).to include(video1)
        expect(vids).to include(video2)
      end

    end

  end


  it 'should validate the uniqueness of the video' do
    original = create(:video)

    vid = build(:video, :external_url => original.external_url, :external_id => original.external_id, :type => original.type)
    vid.save

    expect(vid.errors).to_not be_empty
    expect(vid.errors[:video_exists]).to_not be_nil

  end

  it 'should return all the motifs that have an icon' do

    motif1 = create(:motif)
    motif2 = create(:motif, :icon => fixture_file('ajax-loader.gif'))
    video = create(:video)

    expect(motif1.icon.url).to be_nil
    expect(motif2.icon.url).to_not be_nil

    create(:video_motif, :video => video, :motif => motif1)
    create(:video_motif, :video => video, :motif => motif2)

    expect(video.motifs_with_icon).to include(motif2)
    expect(video.motifs_with_icon).to_not include(motif1)

  end

end