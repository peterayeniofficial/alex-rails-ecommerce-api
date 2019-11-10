# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins *ENV.fetch('ALLOWED_CORS_ORIGINS').split(',')
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :patch, :delete, :options, :head], expose: ['Link']
    end
  end