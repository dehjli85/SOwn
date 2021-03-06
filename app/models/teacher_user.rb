class TeacherUser < ActiveRecord::Base

  has_many :classrooms
  has_many :activities, -> {order 'activities.created_at'}

  validates :first_name, :last_name, :email, presence: true
  validate :has_password_or_external_authentication
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :email, uniqueness: true

  before_validation :downcase_email


  ##################################################################################################
  #
  # Validations
  #
  ##################################################################################################


  def downcase_email
    self.email = self.email.downcase if self.email.present?
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

    if pw.nil?
      @password = nil
      self.salt = nil
      self.password_digest = nil
    end
    
  end

  def has_password_or_external_authentication
    if self.password_digest.nil? && self.provider.nil?
      errors.add(:password, 'can\'t be blank')
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



  def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
  end

  

  # return the number of "real" Student Users
  def self.count
    TeacherUser.where("email not like '%@sowntogrow.com%'").count
  end

  # return the number of "real" Student Users by week
  def self.create_count_by_week
    students = TeacherUser.where("email not like '%@sowntogrow.com%'")
    hash = {}
    students.each do |student|
      year = student.created_at.strftime('%Y')
      week = student.created_at.strftime('%W')
      if !hash[year]
        hash[year] = {}
      end

      if hash[year][week]
        hash[year][week] += 1
      else
        hash[year][week] = 1
      end

    end

    array = []
    years = hash.keys.sort
    years.each_with_index do |year, i|
      weeks = hash[year].keys.sort
      weeks.each_with_index do |week, j|
        array.push({year: years[i], week: weeks[j], count: hash[years[i]][weeks[j]]})
      end
    end

    array
  end

  # return the cumulative number of "real" Student Users by week
  def self.cumulative_create_count_by_week

    array = self.create_count_by_week

    cum = 0
    array.each do |week|
      cum += week[:count]
      week[:count] = cum
    end

    array

  end
  
end
