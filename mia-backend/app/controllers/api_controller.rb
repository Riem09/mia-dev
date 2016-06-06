class ApiController < ApplicationController
  
  skip_before_filter :verify_authenticity_token

  protected

  def render_json(json, status: 200)
    render(json: json, status: status)
  end

  def render_error(errors, status: 400)
    render(json: {error: errors}, status: status)
  end

  def render_message(message, status: 200)
    render_json({message: message}, status: status)
  end

  def render_unauthorized
    render_error("Unauthorized", status: 401)
  end
  
  private

  def access_denied
    render json: {"error": "You do not have permission to access this page"}, status: 403
  end

end
