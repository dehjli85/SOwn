OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '916932200710-197d3s4oroak5c7cmm3cmkoakfahp62e.apps.googleusercontent.com', 'qB_XcvH1gVexOT-RHaZvZ8oZ', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end