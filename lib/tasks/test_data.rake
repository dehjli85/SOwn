namespace :app do
  desc <<-DESC
    Load testing data.
    Run using the command 'rake app:load_demo_data'
  DESC
  task :load_demo_data => [:environment] do

  tables = ['student_users',
    'teacher_users',
    'activities',
    'classrooms',
    'classroom_activity_pairings',
    'student_performances', 
    'classrooms_student_users']
  #ActiveRecord::Base.connection.tables.each do |table|
  tables.each do |table|
    result = ActiveRecord::Base.connection.execute("SELECT id FROM #{table} ORDER BY id DESC LIMIT 1")
    if result.any?
      #ai_val = result.first['id'].to_i + 1
      ai_val = 1
      puts "Resetting auto increment ID for #{table} to #{ai_val}"
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{table}_id_seq RESTART WITH #{ai_val}")
    end
  end

  puts 'deleting all demo student verifications data'
  puts 'deleting all demo student performances data'
  puts 'deleting all demo students'

  students = StudentUser.where("username like 'demo_student%'")

  students.each do |student|
    
    student.student_performance_verifications.each do |verification|
      verification.delete
    end

  
    student.student_performances.each do |performance|
      performance.delete
    end

    student.delete
  end

  puts 'deleting all demo classroom activity pairings'
  puts 'deleting all demo classrooms'

  demo_teacher = TeacherUser.find_by_username("demo_teacher@sowntogrow.com")

  demo_teacher.classrooms.each do |classroom|
    
    classroom.classroom_activity_pairings.each do |pairing|
      pairing.delete
    end   

    classroom.delete
  end

  puts 'deleting demo activity tag pairings'
  puts 'deleting demo activities'
  puts 'deleting demo teacher'
  demo_teacher.activities.each do |activity|
    activity.activity_tag_pairings.each do |pairing|
      pairing.delete  
    end
    activity.delete
  end
  demo_teacher.delete

  # Only data not required in production should be here.
  # If it needs to be there in production, it belongs in seeds.rb.
  

  puts 'adding student data'
  StudentUser.new({username: "demo_student_1@sowntogrow.com", first_name: "Maria", last_name: "Hill", display_name: "Maria Hill", email: "demo_student_1@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_2@sowntogrow.com", first_name: "Ronald", last_name: "Brooks", display_name: "Ronald Brooks", email: "demo_student_2@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_3@sowntogrow.com", first_name: "Lisa", last_name: "Moore", display_name: "Lisa Moore", email: "demo_student_3@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_4@sowntogrow.com", first_name: "Chris", last_name: "Young", display_name: "Chris Young", email: "demo_student_4@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_5@sowntogrow.com", first_name: "Theresa", last_name: "Ramirez", display_name: "Theresa Ramirez", email: "demo_student_5@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_6@sowntogrow.com", first_name: "Anna", last_name: "Brown", display_name: "Anna Brown", email: "demo_student_6@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_7@sowntogrow.com", first_name: "Angela", last_name: "Alexander", display_name: "Angela Alexander", email: "demo_student_7@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_8@sowntogrow.com", first_name: "Benjamin", last_name: "Lee", display_name: "Benjamin Lee", email: "demo_student_8@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_9@sowntogrow.com", first_name: "Timothy", last_name: "Garcia", display_name: "Timothy Garcia", email: "demo_student_9@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_10@sowntogrow.com", first_name: "Sean", last_name: "Hall", display_name: "Sean Hall", email: "demo_student_10@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_11@sowntogrow.com", first_name: "Raymond", last_name: "Williams", display_name: "Raymond Williams", email: "demo_student_11@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_12@sowntogrow.com", first_name: "Helen", last_name: "Diaz", display_name: "Helen Diaz", email: "demo_student_12@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_13@sowntogrow.com", first_name: "Emily", last_name: "Stewart", display_name: "Emily Stewart", email: "demo_student_13@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_14@sowntogrow.com", first_name: "Alan", last_name: "Baker", display_name: "Alan Baker", email: "demo_student_14@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_15@sowntogrow.com", first_name: "Kimberly", last_name: "Wilson", display_name: "Kimberly Wilson", email: "demo_student_15@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_16@sowntogrow.com", first_name: "Donna", last_name: "Bailey", display_name: "Donna Bailey", email: "demo_student_16@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_17@sowntogrow.com", first_name: "Paula", last_name: "Rodriguez", display_name: "Paula Rodriguez", email: "demo_student_17@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_18@sowntogrow.com", first_name: "Carlos", last_name: "Phillips", display_name: "Carlos Phillips", email: "demo_student_18@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_19@sowntogrow.com", first_name: "James", last_name: "Flores", display_name: "James Flores", email: "demo_student_19@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_20@sowntogrow.com", first_name: "Anthony", last_name: "Johnson", display_name: "Anthony Johnson", email: "demo_student_20@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_21@sowntogrow.com", first_name: "Clarence", last_name: "Bryant", display_name: "Clarence Bryant", email: "demo_student_21@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_22@sowntogrow.com", first_name: "Diane", last_name: "Parker", display_name: "Diane Parker", email: "demo_student_22@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_23@sowntogrow.com", first_name: "Howard", last_name: "Miller", display_name: "Howard Miller", email: "demo_student_23@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_24@sowntogrow.com", first_name: "Gary", last_name: "Collins", display_name: "Gary Collins", email: "demo_student_24@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_25@sowntogrow.com", first_name: "Richard", last_name: "Morgan", display_name: "Richard Morgan", email: "demo_student_25@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_26@sowntogrow.com", first_name: "Rachel", last_name: "Murphy", display_name: "Rachel Murphy", email: "demo_student_26@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_27@sowntogrow.com", first_name: "Bobby", last_name: "Scott", display_name: "Bobby Scott", email: "demo_student_27@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_28@sowntogrow.com", first_name: "Harry", last_name: "Kelly", display_name: "Harry Kelly", email: "demo_student_28@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_29@sowntogrow.com", first_name: "Annie", last_name: "Anderson", display_name: "Annie Anderson", email: "demo_student_29@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_30@sowntogrow.com", first_name: "Joe", last_name: "Peterson", display_name: "Joe Peterson", email: "demo_student_30@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_31@sowntogrow.com", first_name: "Bruce", last_name: "Foster", display_name: "Bruce Foster", email: "demo_student_31@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_32@sowntogrow.com", first_name: "Craig", last_name: "Cooper", display_name: "Craig Cooper", email: "demo_student_32@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_33@sowntogrow.com", first_name: "Kathleen", last_name: "Wood", display_name: "Kathleen Wood", email: "demo_student_33@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_34@sowntogrow.com", first_name: "Todd", last_name: "Perez", display_name: "Todd Perez", email: "demo_student_34@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_35@sowntogrow.com", first_name: "Jimmy", last_name: "Gonzalez", display_name: "Jimmy Gonzalez", email: "demo_student_35@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_36@sowntogrow.com", first_name: "Aaron", last_name: "Powell", display_name: "Aaron Powell", email: "demo_student_36@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_37@sowntogrow.com", first_name: "Stephen", last_name: "Perry", display_name: "Stephen Perry", email: "demo_student_37@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_38@sowntogrow.com", first_name: "Andrea", last_name: "Barnes", display_name: "Andrea Barnes", email: "demo_student_38@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_39@sowntogrow.com", first_name: "Nicole", last_name: "Gray", display_name: "Nicole Gray", email: "demo_student_39@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_40@sowntogrow.com", first_name: "Linda", last_name: "Butler", display_name: "Linda Butler", email: "demo_student_40@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_41@sowntogrow.com", first_name: "Anne", last_name: "Clark", display_name: "Anne Clark", email: "demo_student_41@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_42@sowntogrow.com", first_name: "Douglas", last_name: "Adams", display_name: "Douglas Adams", email: "demo_student_42@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_43@sowntogrow.com", first_name: "Barbara", last_name: "Morris", display_name: "Barbara Morris", email: "demo_student_43@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_44@sowntogrow.com", first_name: "Kelly", last_name: "Mitchell", display_name: "Kelly Mitchell", email: "demo_student_44@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_45@sowntogrow.com", first_name: "Donald", last_name: "Griffin", display_name: "Donald Griffin", email: "demo_student_45@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_46@sowntogrow.com", first_name: "Susan", last_name: "Harris", display_name: "Susan Harris", email: "demo_student_46@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_47@sowntogrow.com", first_name: "Joseph", last_name: "Thompson", display_name: "Joseph Thompson", email: "demo_student_47@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_48@sowntogrow.com", first_name: "Margaret", last_name: "Evans", display_name: "Margaret Evans", email: "demo_student_48@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_49@sowntogrow.com", first_name: "Thomas", last_name: "Reed", display_name: "Thomas Reed", email: "demo_student_49@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_50@sowntogrow.com", first_name: "Judy", last_name: "Wright", display_name: "Judy Wright", email: "demo_student_50@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_51@sowntogrow.com", first_name: "George", last_name: "Henderson", display_name: "George Henderson", email: "demo_student_51@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_52@sowntogrow.com", first_name: "Fred", last_name: "Lewis", display_name: "Fred Lewis", email: "demo_student_52@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_53@sowntogrow.com", first_name: "Jessica", last_name: "Ward", display_name: "Jessica Ward", email: "demo_student_53@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_54@sowntogrow.com", first_name: "Victor", last_name: "Cook", display_name: "Victor Cook", email: "demo_student_54@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_55@sowntogrow.com", first_name: "Judith", last_name: "Campbell", display_name: "Judith Campbell", email: "demo_student_55@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_56@sowntogrow.com", first_name: "Rebecca", last_name: "Watson", display_name: "Rebecca Watson", email: "demo_student_56@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_57@sowntogrow.com", first_name: "Frank", last_name: "Nelson", display_name: "Frank Nelson", email: "demo_student_57@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_58@sowntogrow.com", first_name: "Marie", last_name: "Hernandez", display_name: "Marie Hernandez", email: "demo_student_58@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_59@sowntogrow.com", first_name: "Louise", last_name: "Roberts", display_name: "Louise Roberts", email: "demo_student_59@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_60@sowntogrow.com", first_name: "Lillian", last_name: "Price", display_name: "Lillian Price", email: "demo_student_60@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_61@sowntogrow.com", first_name: "Carl", last_name: "Richardson", display_name: "Carl Richardson", email: "demo_student_61@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_62@sowntogrow.com", first_name: "Bonnie", last_name: "Jackson", display_name: "Bonnie Jackson", email: "demo_student_62@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_63@sowntogrow.com", first_name: "Deborah", last_name: "Carter", display_name: "Deborah Carter", email: "demo_student_63@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_64@sowntogrow.com", first_name: "Steven", last_name: "Howard", display_name: "Steven Howard", email: "demo_student_64@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_65@sowntogrow.com", first_name: "Heather", last_name: "Smith", display_name: "Heather Smith", email: "demo_student_65@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_66@sowntogrow.com", first_name: "Mark", last_name: "Gonzales", display_name: "Mark Gonzales", email: "demo_student_66@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_67@sowntogrow.com", first_name: "Jane", last_name: "Robinson", display_name: "Jane Robinson", email: "demo_student_67@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_68@sowntogrow.com", first_name: "Brenda", last_name: "Davis", display_name: "Brenda Davis", email: "demo_student_68@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_69@sowntogrow.com", first_name: "Jack", last_name: "Coleman", display_name: "Jack Coleman", email: "demo_student_69@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_70@sowntogrow.com", first_name: "Phillip", last_name: "Taylor", display_name: "Phillip Taylor", email: "demo_student_70@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_71@sowntogrow.com", first_name: "Lois", last_name: "Green", display_name: "Lois Green", email: "demo_student_71@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_72@sowntogrow.com", first_name: "Albert", last_name: "Sanders", display_name: "Albert Sanders", email: "demo_student_72@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_73@sowntogrow.com", first_name: "Stephanie", last_name: "Simmons", display_name: "Stephanie Simmons", email: "demo_student_73@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_74@sowntogrow.com", first_name: "Randy", last_name: "Russell", display_name: "Randy Russell", email: "demo_student_74@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_75@sowntogrow.com", first_name: "Charles", last_name: "Thomas", display_name: "Charles Thomas", email: "demo_student_75@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_76@sowntogrow.com", first_name: "John", last_name: "Hughes", display_name: "John Hughes", email: "demo_student_76@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_77@sowntogrow.com", first_name: "Eric", last_name: "Edwards", display_name: "Eric Edwards", email: "demo_student_77@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_78@sowntogrow.com", first_name: "Jean", last_name: "Sanchez", display_name: "Jean Sanchez", email: "demo_student_78@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_79@sowntogrow.com", first_name: "Nancy", last_name: "Rivera", display_name: "Nancy Rivera", email: "demo_student_79@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_80@sowntogrow.com", first_name: "Keith", last_name: "Martin", display_name: "Keith Martin", email: "demo_student_80@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_81@sowntogrow.com", first_name: "Robert", last_name: "Turner", display_name: "Robert Turner", email: "demo_student_81@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_82@sowntogrow.com", first_name: "Ralph", last_name: "Torres", display_name: "Ralph Torres", email: "demo_student_82@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_83@sowntogrow.com", first_name: "Arthur", last_name: "Washington", display_name: "Arthur Washington", email: "demo_student_83@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_84@sowntogrow.com", first_name: "Cheryl", last_name: "Long", display_name: "Cheryl Long", email: "demo_student_84@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_85@sowntogrow.com", first_name: "Lawrence", last_name: "Patterson", display_name: "Lawrence Patterson", email: "demo_student_85@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_86@sowntogrow.com", first_name: "Roger", last_name: "Bennett", display_name: "Roger Bennett", email: "demo_student_86@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_87@sowntogrow.com", first_name: "Norma", last_name: "Bell", display_name: "Norma Bell", email: "demo_student_87@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_88@sowntogrow.com", first_name: "Kathryn", last_name: "King", display_name: "Kathryn King", email: "demo_student_88@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_89@sowntogrow.com", first_name: "Teresa", last_name: "Allen", display_name: "Teresa Allen", email: "demo_student_89@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_90@sowntogrow.com", first_name: "Ruby", last_name: "White", display_name: "Ruby White", email: "demo_student_90@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_91@sowntogrow.com", first_name: "Joyce", last_name: "Walker", display_name: "Joyce Walker", email: "demo_student_91@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_92@sowntogrow.com", first_name: "Larry", last_name: "Jones", display_name: "Larry Jones", email: "demo_student_92@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_93@sowntogrow.com", first_name: "Sarah", last_name: "Cox", display_name: "Sarah Cox", email: "demo_student_93@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_94@sowntogrow.com", first_name: "Henry", last_name: "Jenkins", display_name: "Henry Jenkins", email: "demo_student_94@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_95@sowntogrow.com", first_name: "Julie", last_name: "Lopez", display_name: "Julie Lopez", email: "demo_student_95@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_96@sowntogrow.com", first_name: "Virginia", last_name: "James", display_name: "Virginia James", email: "demo_student_96@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_97@sowntogrow.com", first_name: "Lori", last_name: "Ross", display_name: "Lori Ross", email: "demo_student_97@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_98@sowntogrow.com", first_name: "Joan", last_name: "Rogers", display_name: "Joan Rogers", email: "demo_student_98@sowntogrow.com", password: "demo"}).save
  StudentUser.new({username: "demo_student_99@sowntogrow.com", first_name: "Sara", last_name: "Martinez", display_name: "Sara Martinez", email: "demo_student_99@sowntogrow.com", password: "demo"}).save

  

  puts 'adding teacher users'
  demo_teacher = TeacherUser.new({username: "demo_teacher@sowntogrow.com", first_name: "Demo", last_name: "Teacher", display_name: "Demo Teacher", email: "demo_teacher@sowntogrow.com", password: "demo"})
  demo_teacher.save

  puts 'adding activities'
  Activity.new({name:"Multiplication", description: "ThatQuiz", instructions: "90%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 70, benchmark2_score: 90 }).save
  Activity.new({name:"Division", description: "ThatQuiz", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"Long Division1", description: "ThatQuiz", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"Long Division2", description: "ThatQuiz", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"Long Division3", description: "ThatQuiz", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"Multiplication without carrying", description: "Khan", instructions: "5 in a row", teacher_user_id: 1, activity_type: "completion", min_score: nil ,max_score: nil, benchmark1_score: nil, benchmark2_score: nil }).save
  Activity.new({name:"Multiplication with carrying", description: "Khan", instructions: "5 in a row", teacher_user_id: 1, activity_type: "completion", min_score: nil ,max_score: nil, benchmark1_score: nil, benchmark2_score: nil }).save
  Activity.new({name:"Multiplying 2 digits by 2 digits", description: "Khan", instructions: "5 in a row", teacher_user_id: 1, activity_type: "completion", min_score: nil ,max_score: nil, benchmark1_score: nil, benchmark2_score: nil }).save
  Activity.new({name:"Multi-digit division without remainders", description: "Khan", instructions: "5 in a row", teacher_user_id: 1, activity_type: "completion", min_score: nil ,max_score: nil, benchmark1_score: nil, benchmark2_score: nil }).save
  Activity.new({name:"Division with remainders", description: "Khan", instructions: "5 in a row", teacher_user_id: 1, activity_type: "completion", min_score: nil ,max_score: nil, benchmark1_score: nil, benchmark2_score: nil }).save
  Activity.new({name:"Multiplication and division word problems", description: "Khan", instructions: "5 in a row", teacher_user_id: 1, activity_type: "completion", min_score: nil ,max_score: nil, benchmark1_score: nil, benchmark2_score: nil }).save
  Activity.new({name:"GCF", description: "Khan", instructions: "5 in a row", teacher_user_id: 1, activity_type: "completion", min_score: nil ,max_score: nil, benchmark1_score: nil, benchmark2_score: nil }).save
  Activity.new({name:"L3: Fluently Solve Multiplication Problems", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L3: Fluently Solve Division Problems", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L3: Solving Multiplication and Division Verbally", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L4: Multiplication and Division Strategies", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L4: Factors", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L4: Relating Multiplication and Division", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L5: Multiplication with Multi-Digit Whole Numbers", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L5: Dividing Whole Numbers", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L5: Complete Equivalent Fractions", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L5: Finding Equivalent Fractions and Fractions in Simplest Form", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L6: Identifying the Least Common Multiple", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save
  Activity.new({name:"L6: Identifying the Greatest Common Factor", description: "TenMarks", instructions: "80%+", teacher_user_id: 1, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80 }).save


  puts "creating tags (if they don't exist): multiplication, division, khan, tenmarks, L3, L4, L5, L6, ThatQuiz"
  if !ActivityTag.find_by_name('multiplication')
    multiplication_tag = ActivityTag.new({name: 'multiplication'})
    multiplication_tag.save
  else
    multiplication_tag = ActivityTag.find_by_name('multiplication')
  end
  if !ActivityTag.find_by_name('division')
    division_tag = ActivityTag.new({name: 'division'})
    division_tag.save
  else
    division_tag = ActivityTag.find_by_name('division')
  end
  if !ActivityTag.find_by_name('khan')
    khan_tag = ActivityTag.new({name: 'khan'})
    khan_tag.save
  else
    khan_tag = ActivityTag.find_by_name('khan')
  end
  if !ActivityTag.find_by_name('tenmarks')
    tenmarks_tag = ActivityTag.new({name: 'tenmarks'})
    tenmarks_tag.save
  else
    tenmarks_tag = ActivityTag.find_by_name('tenmarks')
  end
  if !ActivityTag.find_by_name('thatquiz')
    thatquiz_tag = ActivityTag.new({name: 'thatquiz'})
    thatquiz_tag.save
  else
    thatquiz_tag = ActivityTag.find_by_name('thatquiz')
  end
  if !ActivityTag.find_by_name('L3')
    l3_tag = ActivityTag.new({name: 'L3'})
    l3_tag.save
  else
    l3_tag = ActivityTag.find_by_name('L3')
  end
  if !ActivityTag.find_by_name('L4')
    l4_tag = ActivityTag.new({name: 'L4'})
    l4_tag.save
  else
    l4_tag = ActivityTag.find_by_name('L4')
  end
  if !ActivityTag.find_by_name('L5')
    l5_tag = ActivityTag.new({name: 'L5'})
    l5_tag.save
  else
    l5_tag = ActivityTag.find_by_name('L5')
  end
  if !ActivityTag.find_by_name('L6')
    l6_tag = ActivityTag.new({name: 'L6'})
    l6_tag.save
  else
    l6_tag = ActivityTag.find_by_name('L6')
  end
  
  puts 'creating tag pairings'
  tu = TeacherUser.find_by_username('demo_teacher@sowntogrow.com')
  tu.activities.each do |activity|
    if activity.name.downcase.include?('multiplication')
      ActivityTagPairing.new({activity_id: activity.id, activity_tag_id: multiplication_tag.id}).save
    end
    if activity.name.downcase.include?('division')
      ActivityTagPairing.new({activity_id: activity.id, activity_tag_id: division_tag.id}).save
    end
    if activity.description.downcase.include?('khan')
      ActivityTagPairing.new({activity_id: activity.id, activity_tag_id: khan_tag.id}).save
    end
    if activity.description.downcase.include?('tenmarks')
      ActivityTagPairing.new({activity_id: activity.id, activity_tag_id: tenmarks_tag.id}).save
    end
    if activity.description.downcase.include?('thatquiz')
      ActivityTagPairing.new({activity_id: activity.id, activity_tag_id: thatquiz_tag.id}).save
    end
    if activity.name.downcase.include?('l3')
      ActivityTagPairing.new({activity_id: activity.id, activity_tag_id: l3_tag.id}).save
    end
    if activity.name.downcase.include?('l4')
      ActivityTagPairing.new({activity_id: activity.id, activity_tag_id: l4_tag.id}).save
    end
    if activity.name.downcase.include?('l5')
      ActivityTagPairing.new({activity_id: activity.id, activity_tag_id: l5_tag.id}).save
    end
    if activity.name.downcase.include?('l6')
      ActivityTagPairing.new({activity_id: activity.id, activity_tag_id: l6_tag.id}).save
    end
  end



  puts 'adding classrooms'
  Classroom.new({teacher_user_id: demo_teacher.id,name: "1st Period Math", classroom_code: "li-1-math"}).save
  Classroom.new({teacher_user_id: demo_teacher.id,name: "2nd Period Math", classroom_code: "li-2-math"}).save
  Classroom.new({teacher_user_id: demo_teacher.id,name: "3rd Period Math", classroom_code: "li-3-math"}).save
  Classroom.new({teacher_user_id: demo_teacher.id,name: "4th Period Math", classroom_code: "li-4-math"}).save

 

  puts 'deleting students in classrooms'
  ClassroomsStudentUsers.delete_all

  puts 'adding students into classrooms'
  students = StudentUser.where("username like 'demo_student%'")
  students.each do |student|
    ClassroomsStudentUsers.new({student_user_id: student.id, classroom_id: demo_teacher.classrooms[(rand()*demo_teacher.classrooms.length).floor].id}).save
  end



  puts 'adding classroom activities'
  demo_teacher.classrooms.each do |classroom|
    demo_teacher.activities.each do |activity|
      ClassroomActivityPairing.new({activity_id: activity.id, classroom_id: classroom.id}).save      
    end
  end


  students.each do |student|
    student.classrooms.first.classroom_activity_pairings.each do |pairing|
      max_attempt_count = 6
      attempts = 0
      previous_score = 0
      last_performance = nil
      for i in 1..max_attempt_count do 

        attempts += 1

        if pairing.activity.activity_type.eql?('scored')

          score = (rand()*(pairing.activity.max_score-previous_score)*0.7).ceil + previous_score
          previous_score = score
          last_performance = StudentPerformance.new({student_user_id: student.id, classroom_activity_pairing_id: pairing.id, scored_performance: score, performance_date: Time.now})
          last_performance.save
          if score > pairing.activity.benchmark2_score
            break
          end

        elsif pairing.activity.activity_type.eql?('completion')
          
          completed = (rand() > 0.8)
          last_performance = StudentPerformance.new({student_user_id: student.id, classroom_activity_pairing_id: pairing.id, completed_performance: completed, performance_date: Time.now})
          last_performance.save
          if completed
            break
          end
        end

      end

      if last_performance.activity.activity_type.eql?('scored') && last_performance.scored_performance <= last_performance.activity.benchmark2_score
        break
      elsif last_performance.activity.activity_type.eql?('completion') && !last_performance.completed_performance
        break
      end

    end

  end

end

end
  

  

