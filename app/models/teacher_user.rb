class TeacherUser < ActiveRecord::Base

  has_many :classrooms
  has_many :activities, -> {order 'activities.created_at'}

  validates :first_name, :last_name, :email, presence: true
  validate :has_password_or_external_authentication
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :email, uniqueness: true


	def self.from_omniauth_sign_up(auth)
    
    puts 'AUTH_HASH:\n' + auth.to_s

    #check to see if the user already exists in the db.  If so, return null.
    # if !where(auth.slice(:provider, :uid).to_hash).first.nil?
    #   return nil
    # end

    #initialize the user if necessary
    user = TeacherUser.new
    user.provider = auth.provider
    user.uid = auth.uid      
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.email = auth.info.email
    user.first_name = auth.info.first_name
    user.last_name = auth.info.last_name
    user.username = auth.info.email
    user.display_name = auth.info.name
      
  

    return user
    

  end

  def self.from_omniauth_log_in(auth)

    #check if the user exists in the db.  If so, return the user, else return nil
    where(auth.slice(:provider, :uid).to_hash).first      

  end


  def password_valid?(pw)
    Digest::SHA1.hexdigest(pw + self.salt.to_s).eql?(self.password_digest)
  end

  def password
    @password
  end

  def password=(pw)
    if !pw.nil? && !pw.strip.eql?("")
      @password = pw
      self.salt = (Random.new.rand*10000).to_i
      self.password_digest = Digest::SHA1.hexdigest(pw + self.salt.to_s)
    end
  end

  def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def has_password_or_external_authentication
    if self.password_digest.nil? && self.provider.nil?
      errors.add(:password, 'can\'t be blank')
    end
  end
  
end
