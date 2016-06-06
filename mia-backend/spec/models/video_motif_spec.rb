require 'rails_helper'

describe VideoMotif do

  before(:each) do

    @m1 = create(:motif)
    @m2 = create(:motif, :parent => @m1)

    create(:video_motif, :motif => @m2)

  end

  it 'Should allow a user to search with an ancestor' do

    expect( VideoMotif.with_ancestor_id(@m1.id).count ).to eq(1)

  end

end