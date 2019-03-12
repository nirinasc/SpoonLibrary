##
# @author nirina
# Json Web Token Util Class for encoding and decoding api request token
class JsonWebToken
  # secret to encode and decode token
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  # encode a user payload to an auth token
  # @param payload [Hash] the user payload
  # @option payload [Integer] :user_id the user id
  # @option exp [Date] the expiry token date
  # @return [String] the generated token
  def self.encode(payload, exp = 24.hours.from_now)
    # set expiry to 24 hours from creation time
    payload[:exp] = exp.to_i
    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  # Decode a token to a User Payload
  # @example
  #   decode("5111qsd") #=> { :user_id => 1, :exp => 1515125}
  # @param token [String] the token to decode
  # @return [Hash] the matched payload 
  # @raise [API::JWTExceptionHandler::InvalidToken] if the token is Invalid
  def self.decode(token)
    # get payload; first index in decoded Array
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body
    # rescue from all decode errors
  rescue JWT::DecodeError => e
    # raise custom error to be handled by custom handler
    raise API::JWTExceptionHandler::InvalidToken, e.message
  end
end
