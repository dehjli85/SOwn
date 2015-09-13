class StudentUser < ActiveRecord::Base

  # has_and_belongs_to_many :classrooms
  has_many :classrooms, :through => :classroom_student_users

  has_many :student_performances, -> {order 'student_performances.created_at'}
  has_many :student_performance_verifications    
  has_many :classroom_student_users

  validates :first_name, :last_name, :email, presence: true
  validate :has_password_or_external_authentication
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :email, uniqueness: true

	def self.from_omniauth_sign_up(auth)
  
    puts 'AUTH_HASH:\n' + auth.to_s

    #check to see if the user already exists in the db.  If so, return null.
    # if !where(auth.slice(:provider, :uid).to_hash).first.nil?
    #   puts "User already exists, fail to sign up"
    #   return nil
    # end

    #initialize the user if necessary
    user = StudentUser.new
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

  def classroom_activities_performance(classroom_id)
    sps = StudentPerformance.where({student_user_id: self.id})
    matched_performances = Array.new
    if !sps.nil?
      sps.each do |sp|
        if sp.activities_classrooms.classroom.id = classroom_id
          matched_performances.push(sp)
        end
        return matched_performances
      end
    else
      return nil
    end
  end

  def has_password_or_external_authentication
    if self.password_digest.nil? && self.provider.nil?
      errors.add(:password, 'can\'t be blank')
    end
  end
  
end
