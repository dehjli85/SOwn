class UsersController < ApplicationController

	require 'net/http'
	require 'jwt'

	def login



	#	@user = (!session[:id].nil? && !User.find(session[:id]).nil?) ? User.find(session[:id]) : User.new
	end

	def post_login

		begin
			decoded_token = JWT.decode params[:idtoken], nil, false
		rescue
			puts 'Invalid JWT'
		end

		if !(decoded_token[0]['iss'].eql?('accounts.google.com') || decoded_token[0]['iss'].eql?('https://accounts.google.com'))
			puts 'Invalid Issuer'
		end

		#if the user is logging in via google, first check if they already exist and authenticate against the access token

		#if the user doesn't exist, create the user, get/store the access token

		#if the access token is all good, set the user_id into the session cookie

	end


end

def verify_token(token)
	errors = Array.new

	iss = 'accounts.google.com or https://account.google.com/'
	begin
  # Add iss to the validation to check if the token has been manipulated
  	decoded_token = JWT.decode token, nil, false, { 'iss' => iss, :verify_iss => true }
	rescue JWT::InvalidIssuerError
	  errors.push('Invalid Issuer')
	end
	

	begin
  	decoded_token = JWT.decode token, nil
	rescue JWT::ExpiredSignature
	  # Handle expired token, e.g. logout user or deny access
	  errors.push('Invalid Expiration')
	end

	aud = ['916932200710-kk91r5rbn820llsernmbjfgk9r5s67lq.apps.googleusercontent.com']

	begin
	  # Add auf to the validation to check if the token has been manipulated
	  decoded_token = JWT.decode token, nil, false, { 'aud' => aud, :verify_aud => true }
	rescue JWT::InvalidAudError
	  # Handle invalid token, e.g. logout user or deny access
	  errors.push ('Audience Error')
	end

end
