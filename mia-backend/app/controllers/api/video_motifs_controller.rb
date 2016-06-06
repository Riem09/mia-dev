class Api::VideoMotifsController < ApiController

  before_action :set_video_motif, only: [:show, :edit, :update, :destroy]
  before_action :login_required, except: [:index, :show]

  # GET /video_motifs
  # GET /video_motifs.json
  def index
    @video_motifs = VideoMotif
      .paginate(page: index_params[:page], per_page: index_params[:per_page])
      .order('created_at DESC')

    @meta = {
      total_pages: VideoMotif.count / index_params[:per_page].to_i
    }

    render json: @video_motifs, :meta => @meta

  end

  # GET /video_motifs/1
  # GET /video_motifs/1.json
  def show
    render :json => @video_motif
  end

  # GET /video_motifs/new
  def new
    @video_motif = VideoMotif.new
  end

  # GET /video_motifs/1/edit
  def edit
  end

  # POST /video_motifs
  # POST /video_motifs.json
  def create
    @video_motif = VideoMotif.new(video_motif_params.merge(:owner => current_user))
    if @video_motif.save
      render :json => @video_motif, :status => :created
    else
      render json: @video_motif.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /video_motifs/1
  # PATCH/PUT /video_motifs/1.json
  def update
    if @video_motif.update({:owner => current_user}.merge(video_motif_params))
      render :json => @video_motif
    else
      render json: @video_motif.errors, status: :unprocessable_entity
    end
  end

  # DELETE /video_motifs/1
  # DELETE /video_motifs/1.json
  def destroy
    @video_motif.destroy
    render :json => @video_motif
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_motif
      @video_motif = VideoMotif.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_motif_params
      params.require(:video_motif).permit(:video_id, :motif_id, :description, :start_time_ms, :end_time_ms)
    end

    def index_params
      params.permit(:page, :per_page)
    end

end
