# spec/support/api_helper.rb
module ApiSpecHelper
    # generate tokens from user id
    def token_generator(user_id)
      JsonWebToken.encode(user_id: user_id)
    end
  
    # generate expired tokens from user id
    def expired_token_generator(user_id)
      JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
    end
  
    def headers(user_id = nil)
      {
        "Authorization" => user_id.present? ? token_generator(user_id) : nil,
        "Content-Type" => "application/json"
      }
    end

    def credentials_tojson(username, password)
      {
        username: username,
        password: password
      }.to_json
    end

    # Parse JSON response to ruby hash
    def json
      JSON.parse(response.body)
    end

end