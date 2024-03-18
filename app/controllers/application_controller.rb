class ApplicationController < ActionController::Base
  rescue_from ActionController::UnknownFormat, with: :raise_not_found
  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def raise_not_found
    raise ActionController::RoutingError.new('Not supported format')
  end

  def render_not_found
    render file: Rails.public_path.join('404.html'), layout: false, status: :not_found
  end
end
