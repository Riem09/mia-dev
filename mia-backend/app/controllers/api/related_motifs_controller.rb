class Api::RelatedMotifsController < ApiController

  respond_to :json

  before_action :login_required

  def create
    @rm = RelatedMotif.create(create_params)
    render :json => @rm
  end

  def destroy
    @rm = RelatedMotif.find(destroy_params)
    @rm.destroy
    render :json => @rm
  end

  protected

  def create_params
    params.require(:related_motif).permit(:motif1_id, :motif2_id)
  end

  def destroy_params
    params.require(:id)
  end

end
