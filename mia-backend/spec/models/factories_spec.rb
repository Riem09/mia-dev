require 'rails_helper'

describe 'Factories' do

  describe 'motif' do
    it 'should create a valid motif' do
      expect(create(:motif)).to be_valid
    end
  end

  describe 'related_motif' do
    it 'should create a valid related motif' do
      expect(create(:related_motif)).to be_valid
    end
  end

  describe 'user' do
    it 'should create a valid user' do
      expect(create(:user)).to be_valid
    end
  end

  describe 'video' do
    it 'should create a valid video' do
      expect(create(:video)).to be_valid
    end
    it 'should create a valid uploaded_video' do
      expect(create(:uploaded_video)).to be_valid
    end
  end

  describe 'video_motifs' do
    it 'should create a valid video motif' do
      expect(create(:video_motif)).to be_valid
    end
  end

  describe 'video_uploads' do
    it 'should create a valid video upload' do
      expect(create(:video_upload)).to be_valid
    end
  end

end