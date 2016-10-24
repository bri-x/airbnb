Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = ENV['GMAIL_USERNAME']
end
