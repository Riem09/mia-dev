class Api::VideosController < ApiController

  ALL_INCLUDES=['video_upload', 'owner']

  DEFAULT_PUBLISHED = true

  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :login_required, except: [:index, :show]

  # GET /videos
  # GET /videos.json
  def index
    ip = index_params()
    published = ip[:published].boolean? ? ip[:published] : (ip[:published].nil? ? DEFAULT_PUBLISHED : ip[:published].to_b)
    @videos = Video.includes(:video_motifs).where(:published => published)
    @motif_ids = ip[:motif_ids] || (ip[:query] || []).select { |val|
      val.starts_with? '__'
    }.map { |val| val[2..-1] }
    @keywords = ip[:keywords] || (ip[:query] || []).select { |val|
      !val.starts_with? '__'
    }
    @videos = @videos.has_combined_motifs(@motif_ids) if !@motif_ids.empty?
    @videos = @videos.keywords_include(@keywords) if !@keywords.empty?
    @videos = @videos.order('created_at DESC')
    render :json => @videos, :include => ALL_INCLUDES
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    render :json => @video, :include => ALL_INCLUDES
  end

  # GET /videos/new
  def new
    @video = Video.new
    render :json => @video
  end

  # GET /videos/1/edit
  def edit
    render :json => @video
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params.merge(:owner => current_user))
    @original = nil
    if (@video.errors[:video_exists])
      @original = Video.where(:external_id => @video.external_id, :type => @video.type).first
    end
    if @video.save
      render :json => @video, :include => ALL_INCLUDES
    else
      render :json => @video.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    if @video.update({:owner => current_user}.merge(video_params))
      render json: @video, :include => ALL_INCLUDES
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    render json: @video, :status => :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:title,
                                    :description,
                                    :published,
                                    :external_url,
                                    :transcript,
                                    :director,
                                    :production,
                                    :fx,
                                    :client,
                                    :industry,
                                    :year,
                                    :location,
                                    :thumbnail_default,
                                    :thumbnail_medium,
                                    :thumbnail_high, 
                                    # video_upload_attributes: [ :source_video ],
                                    :published
                                    )
    end

    def index_params
      params.permit(:format, :nolayout, :page, :published, :motif_ids => [], :keywords => [], :query => [])
    end

end
