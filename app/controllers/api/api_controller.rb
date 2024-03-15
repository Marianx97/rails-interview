module Api
  class ApiController < ActionController::Base
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActionController::UnknownFormat, with: :raise_not_found
    skip_forgery_protection

    def render_unprocessable_entity(error)
      render json: { message: error.record.errors.full_messages.to_sentence },
             status: :unprocessable_entity
    end

    def raise_not_found
      raise ActionController::RoutingError.new('Not supported format')
    end
  end
end
