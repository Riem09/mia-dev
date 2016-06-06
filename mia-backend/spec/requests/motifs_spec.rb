require 'rails_helper'

describe "Motifs" do
  describe "GET /motifs" do

    before(:each) do
      create(:motif)
    end

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get api_motifs_path
      response.status.should be(200)
    end

  end

  describe 'GET /search' do

    before(:each) do
      @m1 = create(:motif, :name => 'mot')
      @m2 = create(:motif, :parent => @m1, :name => 'test')
      @m3 = create(:motif, :name => "motif")
    end

    it 'Should return the exact matches with children' do
      get search_api_motifs_path(:name => 'mot')
      expect( response.status ).to be(200)
    end

  end
end
