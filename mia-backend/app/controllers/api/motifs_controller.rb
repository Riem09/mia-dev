class Api::MotifsController < ApiController

  INCLUDE_ALL=['related_motifs', 'video_upload']

  before_action :login_required, except: [:index, :show, :search, :typeahead]

  before_action do
    @motif = Motif.find(params[:id]) if params[:id]
  end

  # GET /motifs
  # GET /motifs.json
  def index
    doIndex
    render :json => @motifs, :include => ['video_upload']
  end

  def typeahead
    doIndex
    render 'typeahead'
  end

  # GET /random
  # Get a random motif's name.
  def random
    @motif = Motif.order("RANDOM()").first;
    render json: @motif.as_json(only: :name)
  end

  # GET /motifs/1
  # GET /motifs/1.json
  def show
    # raise 'Error'
    render :json => @motif, :include => INCLUDE_ALL, serializer: MotifFullSerializer
  end

  # GET /motifs/new
  def new
    @motif = Motif.new(new_params)
  end

  # GET /motifs/1/edit
  def edit
  end

  # get /motifs/search?name=X
  def search
    motif_name = params.require(:name)
    @exacts = Motif.includes(:video_motifs).includes(:related_motifs).where('motifs.name = ?', motif_name)
    @similar = Motif.includes(:video_motifs).includes(:related_motifs).where('motifs.name != ? AND motifs.name LIKE ?', motif_name, "%#{motif_name}%").order("LENGTH(motifs.name) ASC")
    @matches = []
    @exacts.each do |exact|
      @matches << exact
      @matches = @matches + exact.children + exact.related_motifs.collect(&:motif2)
    end
    @similar.each do |similar|
      @matches << similar
    end
    render :json => @matches
  end

  # POST /motifs
  # POST /motifs.json
  def create
    @motif = Motif.new(motif_params.merge(:owner => current_user))
    @motif.parent = Motif.find motif_params[:parent_id]
    if @motif.save
      render :json => @motif, :include => INCLUDE_ALL
    else
      render :json => @motif.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /motifs/1
  # PATCH/PUT /motifs/1.json
  def update
    ps = motif_params
    if @motif.owner.nil? && ps[:owner_id].blank?
      ps.merge!(owner: current_user)
    end
    @motif.parent = Motif.find motif_params[:parent_id]
    if @motif.update(ps)
      render json: @motif, :include => INCLUDE_ALL
    else
      render json: @motif.errors, status: :unprocessable_entity
    end
  end

  # DELETE /motifs/1
  # DELETE /motifs/1.json
  def destroy
    @motif.destroy
    render :json => @motif
  end

  protected

  def doIndex
    if params[:q]
      @motifs = Motif.with_name_like(params[:q])
    elsif params[:motif_ids]
      @motifs = Motif.where(:id => params[:motif_ids])
    else
      @motifs = Motif.roots.includes(:owner).includes(:related_motifs).includes(:video_motifs).includes(:video_upload)
    end
  end

  private

  def motif_params
    params.require(:motif).permit(:name, :description, :parent_id, :image, :icon, :remote_image_url, :remote_icon_url, :video_upload_attributes => [ :source_video ])
  end

end
