class Api::InvitesController < ApiController

  before_action :admin_required, only: [:index, :create]
  
  def index
    render json: User.where(confirmed_at: nil)
  end

  def create    
    user = User.new(params.require(:user).permit(:first_name, :last_name, :email))
    new_password = SecureRandom.base64(16).gsub(/\W/,'')[0..11]
    user.password = new_password
    user.password_confirmation = new_password
    if user.save
      user.send_invite_email!(password: new_password)
      render_json user
      user.destroy!
    else
      render_error user.errors
    end
  end

  def accept
    user = User.find_by_confirmation_token(params[:id])
    if user.confirm!
      render_json user
    else
      render_error user.errors
    end
  end

end
