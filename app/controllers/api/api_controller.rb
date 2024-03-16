module Api
  class ApiController < ActionController::Base
    rescue_from ActionController::UnknownFormat, with: :raise_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    skip_forgery_protection

    def render_unprocessable_entity(error)
      render json: { message: error.record.errors.full_messages.to_sentence },
             status: :unprocessable_entity
    end

    def render_not_found(error)
      render json: { message: error.message }, status: :not_found
    end

    def raise_not_found
      raise ActionController::RoutingError.new('Not supported format')
    end
  end
end
