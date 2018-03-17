OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['1788079561498907'], ENV['d236b72537f14ca1255460660']


end