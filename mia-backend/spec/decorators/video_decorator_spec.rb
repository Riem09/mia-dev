require 'rails_helper'

describe VideoDecorator do

  before(:each) do
    @video_keywords = create(:video, :description => "foobar")
    @video_motifs = create(:video)
    @vm = create(:video_motif, :video => @video_motifs)
    @vm2 = create(:video_motif, :video => @video_motifs)
  end

  it 'should correctly say whether the metadata included the keywords' do
    dec = @video_keywords.decorate(:context => { :search => { :keywords => ['foobar'] } } )
    expect(dec.search_keywords_matched?).to eq(true)
  end

  it 'should correctly return all of the video motifs that matched the search results' do
    dec = @video_motifs.decorate(:context => { :search => { :motif_ids => [@vm.motif.id, @vm2.motif.id]}})
    expect(dec.matched_video_motifs).to_not be_empty
    expect(dec.matched_video_motifs).to include(@vm)
    expect(dec.matched_video_motifs).to include(@vm2)
  end

end
