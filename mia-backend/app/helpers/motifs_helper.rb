module MotifsHelper
  def motif_image_url(motif)
    if motif.nil? || motif.is_root?
      asset_url('motif_default_bg.jpg')
    elsif motif.image.try(:url)
      motif.image.url
    else
      motif_image_url(motif.parent)
    end
  end
end
