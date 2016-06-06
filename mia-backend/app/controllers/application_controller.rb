class ApplicationController < ActionController::Base
  include ActionController::Serialization

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  private

  def access_denied
    render plain: "You do not have permission to access this page", status: 403
  end

  def login_required
    access_denied unless current_user.is_a? User
  end

  def admin_required
    access_denied unless current_user.admin?
  end

  def current_user
    @user ||= (User.find_by_id(session[:user_id]) || User.find_by_api_key(raw_api_token))
  end

  def raw_api_token
    if !request.headers["X-API-Key"].blank?
      return request.headers["X-API-Key"]
    elsif !params[:api_key].blank?
      return params[:api_key]
    else
      return ""
    end
  end

end
