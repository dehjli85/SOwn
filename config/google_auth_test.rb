path = Rails.root.to_s + "/config/client_secret_916932200710-kk91r5rbn820llsernmbjfgk9r5s67lq.apps.googleusercontent.com.json"

client_secrets = Google::APIClient::ClientSecrets.load(path)

auth_client = client_secrets.to_authorization

auth_client.update!(
  # :scope => 'https://www.googleapis.com/auth/drive.metadata.readonly',
  :redirect_uri => "http://localhost:3000/auth/google_oauth2/callback"

)

auth_client.authorization.redirect_uri = "http://localhost:3000/auth/google_oauth2/callback"

auth_client.code = "4/SZ9S-yPmHTu8V7vgFss--ZZXQC0W9UBK-4u0ZM2Jsl4"

auth_uri = auth_client.authorization_uri.to_s

auth_client.fetch_access_token!


CLIENT_ID = '916932200710-kk91r5rbn820llsernmbjfgk9r5s67lq.apps.googleusercontent.com'
CLIENT_SECRET = 'ChRBz6wJ1EoEzOXqHz2tMkwe'
REDIRECT_URI = 'http://localhost:3000/auth/google_oauth2/callback'
REDIRECT_URI = 'postmessage'
SCOPES = [
  'email',
  'profile',
  # Add other requested scopes.
]


client = Google::APIClient.new
client.authorization.client_id = CLIENT_ID
client.authorization.client_secret = CLIENT_SECRET
client.authorization.redirect_uri = "postmessage"






client.authorization.code = "4/oDCFfLSiq7dIj4KkUUaNE6wg8eJA2enxnRlQoM3LPZA"

credentials = client.authorization.fetch_access_token!