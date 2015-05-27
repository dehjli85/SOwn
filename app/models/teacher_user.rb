class TeacherUser < ActiveRecord::Base

	def self.from_omniauth(auth)
    
    puts 'AUTH_HASH:\n' + auth.to_s

    #initialize the user if necessary
    where(auth.slice(:provider, :uid).to_hash).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid      
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end

    #create update the users profile info
    retrieved_user = where(auth.slice(:provider, :uid).to_hash).first
    retrieved_user.display_name = auth.info.name
    retrieved_user.first_name = auth.info.given_name
    retrieved_user.last_name = auth.info.family_name
    retrieved_user.email = auth.info.email
    retrieved_user.username = auth.info.email
    retrieved_user.save!

    retrieved_user

  end
end
