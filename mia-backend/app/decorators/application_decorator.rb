class ApplicationDecorator < Draper::Decorator
  def search_keywords
    context[:search][:keywords]
  end
  def search_motif_ids
    context[:search][:motif_ids]
  end
end