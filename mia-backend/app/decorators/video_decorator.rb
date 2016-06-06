class VideoDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def search_keywords_matched?
    found = false
    search_keywords.each do |keyword|
      found = self.title.include?(keyword) || self.description.include?(keyword)
    end
    found
  end

  def matched_video_motifs
    @matched_video_motifs ||= get_matched_video_motifs
  end

  protected

  def get_matched_video_motifs
    matched_vms = []
    search_motif_ids.each do |motif_id|
      object.video_motifs.with_ancestor_id(motif_id).each do |vm|
        matched_vms << vm
      end
    end
    matched_vms.uniq
  end

end
