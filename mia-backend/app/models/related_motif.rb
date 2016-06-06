class RelatedMotif < ActiveRecord::Base

  validate :motifs_cant_be_same

  belongs_to :motif1, :class_name => 'Motif'
  belongs_to :motif2, :class_name => 'Motif'

  def motifs_cant_be_same
    if motif1_id == motif2_id
      errors.add(:motif2, "for id #{id}: can't be the same motif: #{motif1_id} == #{motif2_id}")
    end
  end
end
