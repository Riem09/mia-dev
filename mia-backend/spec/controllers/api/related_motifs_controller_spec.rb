require 'rails_helper'

describe Api::RelatedMotifsController do

  before(:each) do
    @u = create(:user)
  end

  describe 'CREATE' do

    before(:each) do
      @m1 = create(:motif)
      @m2 = create(:motif)
      @valid_create_params = {
          :related_motif => {
              :motif1_id => @m1.id,
              :motif2_id => @m2.id
          },
          :format => :json
      }
    end

    it 'should not allow anonymous users to create a related motif' do
      post :create, @valid_create_params
      expect(response.status).to eq(403)
    end

    it 'should allow logged in users to create a related motif' do
      sign_in @u
      expect {
        post :create, @valid_create_params
      }.to change(RelatedMotif, :count).by(1)
      expect(response.status).to eq(200)
    end

  end


  describe 'DELETE' do

    before(:each) do
      @rm = create(:related_motif)
      @valid_delete_params = { :id => @rm.id,
                               :format => :json }
    end

    it 'should not allow anonymous users to delete related motifs' do
      delete :destroy, @valid_delete_params
      expect(response.status).to eq(403)
    end

    it 'should allow people to delete related motifs' do
      sign_in @u
      expect {
        delete :destroy, @valid_delete_params
      }.to change(RelatedMotif, :count).by(-1)
      expect(response.status).to eq(200)
    end

  end

end