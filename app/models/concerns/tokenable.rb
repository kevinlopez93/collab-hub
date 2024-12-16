module Tokenable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_token, unless: :token?, on: :create
  end

  def generate_token
    self.token = SecureRandom.uuid
  end
end
