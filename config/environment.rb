# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Fix for certifications
ENV['SSL_CERT_FILE'] = "/etc/openssl/certs/cacert.pem"

# Initialize the Rails application.
Rails.application.initialize!

