# @author nirina
# API JWTExceptionHandler Controller Concern
module API::JWTExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class InactiveAccount < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from API::JWTExceptionHandler::AuthenticationError, with: :bad_request
    rescue_from API::JWTExceptionHandler::InactiveAccount, with: :unauthorized_request
    rescue_from API::JWTExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from API::JWTExceptionHandler::InvalidToken, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message }, status: :not_found
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  # @param exception [StandardError] the Exception to extract message from
  # @return [ActionDispatch::Response] JSON with 422 status code
  def four_twenty_two(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  # JSON response with message; Status code 401 - Unauthorized
  # @param exception [StandardError] the Exception to extract message from
  # @return [ActionDispatch::Response] JSON with 401 status code
  def unauthorized_request(exception)
    render json: { message: exception.message }, status: :unauthorized
  end

  # JSON response with message; Status code 400 - Bad Request
  # @param exception [StandardError] the Exception to extract message from
  # @return [ActionDispatch::Response] JSON body with 400 status code
  def bad_request(exception)
    render json: { message: exception.message }, status: :bad_request
  end
end
