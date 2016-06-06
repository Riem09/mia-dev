class Api::UsersController < ApiController

  before_action :set_user, :only => [:show]
  before_action :login_required, except: [:show, :authenticate]

  def show
    if current_user.id == @user.id
      render json: @user, serializer: UserSerializer
    else
      render json: @user, serializer: GuestUserSerializer
    end
  end

  def authenticate
    authenticated_user = User.authenticate(email: params[:email], password: params[:password])
    if authenticated_user
      session[:user_id] = authenticated_user.id
      render json: authenticated_user, serializer: AuthenticationSerializer
    else
      render_unauthorized
    end
  end

  def reset
    User.reset_password!(email: params[:email])
    render_message "Sent"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
