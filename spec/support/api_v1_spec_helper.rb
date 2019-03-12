# @author nirina
# V1 API Test Helper
module ApiV1SpecHelper
  # generate tokens from user id
  # @param user_id [Integer] the id of User
  # @return [String] the generated token
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # generate expired tokens from user id
  # @pram user_id [Integer] the id of User
  # @return [String] the generated token
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  # Generate api request headers for a user
  # @param user_id [Integer], a user id set
  # @return [Hash] the result Header
  def headers(user_id = nil)
    {
      'Authorization' => user_id.present? ? token_generator(user_id) : nil,
      'Content-Type' => 'application/json'
    }
  end

  # Generate JSON Object representation of user credentials
  # @param username [String] the user's username
  # @param password [String] the user's password
  # @return [Hash] the JSON result
  def credentials_tojson(username, password)
    {
      username: username,
      password: password
    }.to_json
  end

  # Parse JSON response to ruby hash
  # @return [Hash] the parse result
  def json
    JSON.parse(response.body)
  end
end
