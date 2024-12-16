class JsonWebToken
  SECRET_KEY = ENV.fetch("JWT_PASSWORD", "")
  def self.decode(token, public_key = SECRET_KEY, algorithm = 'HS256')
    raise JWT::DecodeError if token.blank?
    
    decoded = JWT.decode(token, public_key, !Rails.env.development?, { algorithm: algorithm })[0]
    HashWithIndifferentAccess.new decoded
  end

  def self.encode(payload, algorithm = 'HS256', password = SECRET_KEY)
    JWT.encode(payload, password, algorithm)
  end

  def self.generate_token(user)
    payload = { 
      user_id: user.id,
      email: user.email,
      username: user.username,
      exp: (Time.now + 30.days.freeze).to_i
    }

    encode(payload)
  end
end