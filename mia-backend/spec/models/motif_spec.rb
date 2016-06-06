require 'rails_helper'

describe Motif do

  describe "path" do

    it "Should correctly return all of it's parents" do
      m1 = create(:motif)
      m2 = create(:motif, :parent => m1)
      m3 = create(:motif, :parent => m2)
      expect( m3.path ).to eq([Motif.RootMotif, m1,m2,m3])
    end

  end

  describe 'hex colour' do
    it 'should correctly return the corresponding hex colour' do
      m1 = create(:motif)
      expect( m1.hex_color ).to eq( Motif::MOTIF_COLOURS[ m1.id % Motif::MOTIF_COLOURS.length ] )
    end

    it 'should correctly return its ancestors hex color' do
      m1 = create(:motif)
      m2 = create(:motif, :parent => m1)
      m3 = create(:motif, :parent => m2)
      expect( m3.hex_color ).to eq( m1.hex_color )
    end

  end

  describe 'validate parent' do

    it 'cannot be its own parent' do
      m1 = create(:motif)
      m1.parent = m1
      expect(m1.valid?).to be(false)
    end

    it 'cannot be its own ancestor' do
      m1 = create(:motif)
      m2 = create(:motif, :parent => m1)

      m1.parent = m2
      expect(m1.valid?).to be(false)
    end


  end


  describe '#update_path' do
    let(:parent) { create(:motif) }
    let(:parent2) { create(:motif) }
    let(:motif) { create(:motif, parent: parent) }

    it 'should update ancestors' do
      # ensure that the ancestor is correct
      expect(motif.motif_ancestors.map(&:ancestor)).to include(parent)

      # now we move
      motif.update(parent: parent2)
      expect(motif.motif_ancestors.map(&:ancestor)).not_to include(parent)
      expect(motif.motif_ancestors.map(&:ancestor)).to include(parent2)
    end

    it 'should update the childrens ancestors' do
      # create a child
      submotif = create(:motif, parent: motif)
      # child should also have the ancestor
      expect(submotif.motif_ancestors.map(&:ancestor)).to include(parent)
      expect(motif.reload.children).to include(submotif)

      # now move
      motif.update(parent: parent2)
      expect(motif.motif_ancestors.map(&:ancestor)).to include(parent2)
      submotif.reload
      expect(submotif.motif_ancestors.map(&:ancestor)).not_to include(parent)
      expect(submotif.motif_ancestors.map(&:ancestor)).to include(parent2)
    end
  end

end
