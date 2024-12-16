# frozen_string_literal: true

module RequestHelpers
  def login(user)
    jwt = user.generate_jwt
    headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{jwt}" }
    request.headers.merge! headers
  end

  def json
    @json ||= response.parsed_body
  end

  def clear_json
    @json = nil
  end
end
