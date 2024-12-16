# frozen_string_literal: true

# Solo para hacer pruebas en ambiente QA, CAMBIAR ANTES DE PASAR A PROD
# if Rails.env.development?
# require 'sidekiq/testing'
# Sidekiq::Testing.inline!
# end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/0") }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/0") }
end
