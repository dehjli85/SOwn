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

  
  ##################################################################################################
  #
  # Validations
  #
  ##################################################################################################

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

  def has_password_or_external_authentication
    if self.password_digest.nil? && self.provider.nil?
      errors.add(:password, 'cannot be blank, or you must sign up with Google Authentication')
    end
  end

  ##################################################################################################
  #
  # Model API Methods
  #
  ##################################################################################################

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

  # check if the user exists in the db.  If so, return the user, else return nil
  def self.from_omniauth_log_in(auth)

    where(auth.slice(:provider, :uid).to_hash).first      

  end

  # return the number of "real" Student Users
  def self.count
    StudentUser.where("email not like '%@sowntogrow.com%'").count
  end

  # return the number of "real" Student Users by week
  def self.create_count_by_week
    students = StudentUser.where("email not like '%@sowntogrow.com%'")
    hash = {}
    students.each do |student|
      week = student.created_at.strftime('(%Y) %W')
      if(hash[week])
        hash[week] += 1
      else
        hash[week] = 1
      end
    end

    hash
  end

  # return the cumulative number of "real" Student Users by week
  def self.cumulative_create_count_by_week
    hash = self.create_count_by_week

    cum = 0
    hash.each do |key, value|
      cum += value
      hash[key] = cum

    end

    hash
  end

  
  
end
