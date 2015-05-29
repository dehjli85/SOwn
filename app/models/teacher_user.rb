class TeacherUser < ActiveRecord::Base

  has_many :classrooms


	def self.from_omniauth_sign_up(auth)
    
    puts 'AUTH_HASH:\n' + auth.to_s

    #check to see if the user already exists in the db.  If so, return null.
    if !where(auth.slice(:provider, :uid).to_hash).first.nil?
      return nil
    end

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

  def self.from_omniauth_log_in(auth)

    #check if the user exists in the db.  If so, return the user, else return nil
    where(auth.slice(:provider, :uid).to_hash).first      

  end
end
