namespace :app do
  desc <<-DESC
    Load testing data.
    Run using the command 'rake app:load_demo_data'
  DESC
  task :load_demo_data => [:environment] do

  # Only data not required in production should be here.
  # If it needs to be there in production, it belongs in seeds.rb.
  puts 'deleting student data'
  StudentUser.delete_all

  puts 'adding student data'
  StudentUser.new({id:1 , username: "test1@test.com", first_name: "Maria ", last_name: "Hill", display_name: "Maria  Hill", email: "test1@test.com", password: "test"}).save
  StudentUser.new({id:2 , username: "test2@test.com", first_name: "Ronald ", last_name: "Brooks", display_name: "Ronald  Brooks", email: "test2@test.com", password: "test"}).save
  StudentUser.new({id:3 , username: "test3@test.com", first_name: "Lisa ", last_name: "Moore", display_name: "Lisa  Moore", email: "test3@test.com", password: "test"}).save
  StudentUser.new({id:4 , username: "test4@test.com", first_name: "Chris ", last_name: "Young", display_name: "Chris  Young", email: "test4@test.com", password: "test"}).save
  StudentUser.new({id:5 , username: "test5@test.com", first_name: "Theresa ", last_name: "Ramirez", display_name: "Theresa  Ramirez", email: "test5@test.com", password: "test"}).save
  StudentUser.new({id:6 , username: "test6@test.com", first_name: "Anna ", last_name: "Brown", display_name: "Anna  Brown", email: "test6@test.com", password: "test"}).save
  StudentUser.new({id:7 , username: "test7@test.com", first_name: "Angela ", last_name: "Alexander", display_name: "Angela  Alexander", email: "test7@test.com", password: "test"}).save
  StudentUser.new({id:8 , username: "test8@test.com", first_name: "Benjamin ", last_name: "Lee", display_name: "Benjamin  Lee", email: "test8@test.com", password: "test"}).save
  StudentUser.new({id:9 , username: "test9@test.com", first_name: "Timothy ", last_name: "Garcia", display_name: "Timothy  Garcia", email: "test9@test.com", password: "test"}).save
  StudentUser.new({id:10 , username: "test10@test.com", first_name: "Sean ", last_name: "Hall", display_name: "Sean  Hall", email: "test10@test.com", password: "test"}).save
  StudentUser.new({id:11 , username: "test11@test.com", first_name: "Raymond ", last_name: "Williams", display_name: "Raymond  Williams", email: "test11@test.com", password: "test"}).save
  StudentUser.new({id:12 , username: "test12@test.com", first_name: "Helen ", last_name: "Diaz", display_name: "Helen  Diaz", email: "test12@test.com", password: "test"}).save
  StudentUser.new({id:13 , username: "test13@test.com", first_name: "Emily ", last_name: "Stewart", display_name: "Emily  Stewart", email: "test13@test.com", password: "test"}).save
  StudentUser.new({id:14 , username: "test14@test.com", first_name: "Alan ", last_name: "Baker", display_name: "Alan  Baker", email: "test14@test.com", password: "test"}).save
  StudentUser.new({id:15 , username: "test15@test.com", first_name: "Kimberly ", last_name: "Wilson", display_name: "Kimberly  Wilson", email: "test15@test.com", password: "test"}).save
  StudentUser.new({id:16 , username: "test16@test.com", first_name: "Donna ", last_name: "Bailey", display_name: "Donna  Bailey", email: "test16@test.com", password: "test"}).save
  StudentUser.new({id:17 , username: "test17@test.com", first_name: "Paula ", last_name: "Rodriguez", display_name: "Paula  Rodriguez", email: "test17@test.com", password: "test"}).save
  StudentUser.new({id:18 , username: "test18@test.com", first_name: "Carlos ", last_name: "Phillips", display_name: "Carlos  Phillips", email: "test18@test.com", password: "test"}).save
  StudentUser.new({id:19 , username: "test19@test.com", first_name: "James ", last_name: "Flores", display_name: "James  Flores", email: "test19@test.com", password: "test"}).save
  StudentUser.new({id:20 , username: "test20@test.com", first_name: "Anthony ", last_name: "Johnson", display_name: "Anthony  Johnson", email: "test20@test.com", password: "test"}).save
  StudentUser.new({id:21 , username: "test21@test.com", first_name: "Clarence ", last_name: "Bryant", display_name: "Clarence  Bryant", email: "test21@test.com", password: "test"}).save
  StudentUser.new({id:22 , username: "test22@test.com", first_name: "Diane ", last_name: "Parker", display_name: "Diane  Parker", email: "test22@test.com", password: "test"}).save
  StudentUser.new({id:23 , username: "test23@test.com", first_name: "Howard ", last_name: "Miller", display_name: "Howard  Miller", email: "test23@test.com", password: "test"}).save
  StudentUser.new({id:24 , username: "test24@test.com", first_name: "Gary ", last_name: "Collins", display_name: "Gary  Collins", email: "test24@test.com", password: "test"}).save
  StudentUser.new({id:25 , username: "test25@test.com", first_name: "Richard ", last_name: "Morgan", display_name: "Richard  Morgan", email: "test25@test.com", password: "test"}).save
  StudentUser.new({id:26 , username: "test26@test.com", first_name: "Rachel ", last_name: "Murphy", display_name: "Rachel  Murphy", email: "test26@test.com", password: "test"}).save
  StudentUser.new({id:27 , username: "test27@test.com", first_name: "Bobby ", last_name: "Scott", display_name: "Bobby  Scott", email: "test27@test.com", password: "test"}).save
  StudentUser.new({id:28 , username: "test28@test.com", first_name: "Harry ", last_name: "Kelly", display_name: "Harry  Kelly", email: "test28@test.com", password: "test"}).save
  StudentUser.new({id:29 , username: "test29@test.com", first_name: "Annie ", last_name: "Anderson", display_name: "Annie  Anderson", email: "test29@test.com", password: "test"}).save
  StudentUser.new({id:30 , username: "test30@test.com", first_name: "Joe ", last_name: "Peterson", display_name: "Joe  Peterson", email: "test30@test.com", password: "test"}).save
  StudentUser.new({id:31 , username: "test31@test.com", first_name: "Bruce ", last_name: "Foster", display_name: "Bruce  Foster", email: "test31@test.com", password: "test"}).save
  StudentUser.new({id:32 , username: "test32@test.com", first_name: "Craig ", last_name: "Cooper", display_name: "Craig  Cooper", email: "test32@test.com", password: "test"}).save
  StudentUser.new({id:33 , username: "test33@test.com", first_name: "Kathleen ", last_name: "Wood", display_name: "Kathleen  Wood", email: "test33@test.com", password: "test"}).save
  StudentUser.new({id:34 , username: "test34@test.com", first_name: "Todd ", last_name: "Perez", display_name: "Todd  Perez", email: "test34@test.com", password: "test"}).save
  StudentUser.new({id:35 , username: "test35@test.com", first_name: "Jimmy ", last_name: "Gonzalez", display_name: "Jimmy  Gonzalez", email: "test35@test.com", password: "test"}).save
  StudentUser.new({id:36 , username: "test36@test.com", first_name: "Aaron ", last_name: "Powell", display_name: "Aaron  Powell", email: "test36@test.com", password: "test"}).save
  StudentUser.new({id:37 , username: "test37@test.com", first_name: "Stephen ", last_name: "Perry", display_name: "Stephen  Perry", email: "test37@test.com", password: "test"}).save
  StudentUser.new({id:38 , username: "test38@test.com", first_name: "Andrea ", last_name: "Barnes", display_name: "Andrea  Barnes", email: "test38@test.com", password: "test"}).save
  StudentUser.new({id:39 , username: "test39@test.com", first_name: "Nicole ", last_name: "Gray", display_name: "Nicole  Gray", email: "test39@test.com", password: "test"}).save
  StudentUser.new({id:40 , username: "test40@test.com", first_name: "Linda ", last_name: "Butler", display_name: "Linda  Butler", email: "test40@test.com", password: "test"}).save
  StudentUser.new({id:41 , username: "test41@test.com", first_name: "Anne ", last_name: "Clark", display_name: "Anne  Clark", email: "test41@test.com", password: "test"}).save
  StudentUser.new({id:42 , username: "test42@test.com", first_name: "Douglas ", last_name: "Adams", display_name: "Douglas  Adams", email: "test42@test.com", password: "test"}).save
  StudentUser.new({id:43 , username: "test43@test.com", first_name: "Barbara ", last_name: "Morris", display_name: "Barbara  Morris", email: "test43@test.com", password: "test"}).save
  StudentUser.new({id:44 , username: "test44@test.com", first_name: "Kelly ", last_name: "Mitchell", display_name: "Kelly  Mitchell", email: "test44@test.com", password: "test"}).save
  StudentUser.new({id:45 , username: "test45@test.com", first_name: "Donald ", last_name: "Griffin", display_name: "Donald  Griffin", email: "test45@test.com", password: "test"}).save
  StudentUser.new({id:46 , username: "test46@test.com", first_name: "Susan ", last_name: "Harris", display_name: "Susan  Harris", email: "test46@test.com", password: "test"}).save
  StudentUser.new({id:47 , username: "test47@test.com", first_name: "Joseph ", last_name: "Thompson", display_name: "Joseph  Thompson", email: "test47@test.com", password: "test"}).save
  StudentUser.new({id:48 , username: "test48@test.com", first_name: "Margaret ", last_name: "Evans", display_name: "Margaret  Evans", email: "test48@test.com", password: "test"}).save
  StudentUser.new({id:49 , username: "test49@test.com", first_name: "Thomas ", last_name: "Reed", display_name: "Thomas  Reed", email: "test49@test.com", password: "test"}).save
  StudentUser.new({id:50 , username: "test50@test.com", first_name: "Judy ", last_name: "Wright", display_name: "Judy  Wright", email: "test50@test.com", password: "test"}).save
  StudentUser.new({id:51 , username: "test51@test.com", first_name: "George ", last_name: "Henderson", display_name: "George  Henderson", email: "test51@test.com", password: "test"}).save
  StudentUser.new({id:52 , username: "test52@test.com", first_name: "Fred ", last_name: "Lewis", display_name: "Fred  Lewis", email: "test52@test.com", password: "test"}).save
  StudentUser.new({id:53 , username: "test53@test.com", first_name: "Jessica ", last_name: "Ward", display_name: "Jessica  Ward", email: "test53@test.com", password: "test"}).save
  StudentUser.new({id:54 , username: "test54@test.com", first_name: "Victor ", last_name: "Cook", display_name: "Victor  Cook", email: "test54@test.com", password: "test"}).save
  StudentUser.new({id:55 , username: "test55@test.com", first_name: "Judith ", last_name: "Campbell", display_name: "Judith  Campbell", email: "test55@test.com", password: "test"}).save
  StudentUser.new({id:56 , username: "test56@test.com", first_name: "Rebecca ", last_name: "Watson", display_name: "Rebecca  Watson", email: "test56@test.com", password: "test"}).save
  StudentUser.new({id:57 , username: "test57@test.com", first_name: "Frank ", last_name: "Nelson", display_name: "Frank  Nelson", email: "test57@test.com", password: "test"}).save
  StudentUser.new({id:58 , username: "test58@test.com", first_name: "Marie ", last_name: "Hernandez", display_name: "Marie  Hernandez", email: "test58@test.com", password: "test"}).save
  StudentUser.new({id:59 , username: "test59@test.com", first_name: "Louise ", last_name: "Roberts", display_name: "Louise  Roberts", email: "test59@test.com", password: "test"}).save
  StudentUser.new({id:60 , username: "test60@test.com", first_name: "Lillian ", last_name: "Price", display_name: "Lillian  Price", email: "test60@test.com", password: "test"}).save
  StudentUser.new({id:61 , username: "test61@test.com", first_name: "Carl ", last_name: "Richardson", display_name: "Carl  Richardson", email: "test61@test.com", password: "test"}).save
  StudentUser.new({id:62 , username: "test62@test.com", first_name: "Bonnie ", last_name: "Jackson", display_name: "Bonnie  Jackson", email: "test62@test.com", password: "test"}).save
  StudentUser.new({id:63 , username: "test63@test.com", first_name: "Deborah ", last_name: "Carter", display_name: "Deborah  Carter", email: "test63@test.com", password: "test"}).save
  StudentUser.new({id:64 , username: "test64@test.com", first_name: "Steven ", last_name: "Howard", display_name: "Steven  Howard", email: "test64@test.com", password: "test"}).save
  StudentUser.new({id:65 , username: "test65@test.com", first_name: "Heather ", last_name: "Smith", display_name: "Heather  Smith", email: "test65@test.com", password: "test"}).save
  StudentUser.new({id:66 , username: "test66@test.com", first_name: "Mark ", last_name: "Gonzales", display_name: "Mark  Gonzales", email: "test66@test.com", password: "test"}).save
  StudentUser.new({id:67 , username: "test67@test.com", first_name: "Jane ", last_name: "Robinson", display_name: "Jane  Robinson", email: "test67@test.com", password: "test"}).save
  StudentUser.new({id:68 , username: "test68@test.com", first_name: "Brenda ", last_name: "Davis", display_name: "Brenda  Davis", email: "test68@test.com", password: "test"}).save
  StudentUser.new({id:69 , username: "test69@test.com", first_name: "Jack ", last_name: "Coleman", display_name: "Jack  Coleman", email: "test69@test.com", password: "test"}).save
  StudentUser.new({id:70 , username: "test70@test.com", first_name: "Phillip ", last_name: "Taylor", display_name: "Phillip  Taylor", email: "test70@test.com", password: "test"}).save
  StudentUser.new({id:71 , username: "test71@test.com", first_name: "Lois ", last_name: "Green", display_name: "Lois  Green", email: "test71@test.com", password: "test"}).save
  StudentUser.new({id:72 , username: "test72@test.com", first_name: "Albert ", last_name: "Sanders", display_name: "Albert  Sanders", email: "test72@test.com", password: "test"}).save
  StudentUser.new({id:73 , username: "test73@test.com", first_name: "Stephanie ", last_name: "Simmons", display_name: "Stephanie  Simmons", email: "test73@test.com", password: "test"}).save
  StudentUser.new({id:74 , username: "test74@test.com", first_name: "Randy ", last_name: "Russell", display_name: "Randy  Russell", email: "test74@test.com", password: "test"}).save
  StudentUser.new({id:75 , username: "test75@test.com", first_name: "Charles ", last_name: "Thomas", display_name: "Charles  Thomas", email: "test75@test.com", password: "test"}).save
  StudentUser.new({id:76 , username: "test76@test.com", first_name: "John ", last_name: "Hughes", display_name: "John  Hughes", email: "test76@test.com", password: "test"}).save
  StudentUser.new({id:77 , username: "test77@test.com", first_name: "Eric ", last_name: "Edwards", display_name: "Eric  Edwards", email: "test77@test.com", password: "test"}).save
  StudentUser.new({id:78 , username: "test78@test.com", first_name: "Jean ", last_name: "Sanchez", display_name: "Jean  Sanchez", email: "test78@test.com", password: "test"}).save
  StudentUser.new({id:79 , username: "test79@test.com", first_name: "Nancy ", last_name: "Rivera", display_name: "Nancy  Rivera", email: "test79@test.com", password: "test"}).save
  StudentUser.new({id:80 , username: "test80@test.com", first_name: "Keith ", last_name: "Martin", display_name: "Keith  Martin", email: "test80@test.com", password: "test"}).save
  StudentUser.new({id:81 , username: "test81@test.com", first_name: "Robert ", last_name: "Turner", display_name: "Robert  Turner", email: "test81@test.com", password: "test"}).save
  StudentUser.new({id:82 , username: "test82@test.com", first_name: "Ralph ", last_name: "Torres", display_name: "Ralph  Torres", email: "test82@test.com", password: "test"}).save
  StudentUser.new({id:83 , username: "test83@test.com", first_name: "Arthur ", last_name: "Washington", display_name: "Arthur  Washington", email: "test83@test.com", password: "test"}).save
  StudentUser.new({id:84 , username: "test84@test.com", first_name: "Cheryl ", last_name: "Long", display_name: "Cheryl  Long", email: "test84@test.com", password: "test"}).save
  StudentUser.new({id:85 , username: "test85@test.com", first_name: "Lawrence ", last_name: "Patterson", display_name: "Lawrence  Patterson", email: "test85@test.com", password: "test"}).save
  StudentUser.new({id:86 , username: "test86@test.com", first_name: "Roger ", last_name: "Bennett", display_name: "Roger  Bennett", email: "test86@test.com", password: "test"}).save
  StudentUser.new({id:87 , username: "test87@test.com", first_name: "Norma ", last_name: "Bell", display_name: "Norma  Bell", email: "test87@test.com", password: "test"}).save
  StudentUser.new({id:88 , username: "test88@test.com", first_name: "Kathryn ", last_name: "King", display_name: "Kathryn  King", email: "test88@test.com", password: "test"}).save
  StudentUser.new({id:89 , username: "test89@test.com", first_name: "Teresa ", last_name: "Allen", display_name: "Teresa  Allen", email: "test89@test.com", password: "test"}).save
  StudentUser.new({id:90 , username: "test90@test.com", first_name: "Ruby ", last_name: "White", display_name: "Ruby  White", email: "test90@test.com", password: "test"}).save
  StudentUser.new({id:91 , username: "test91@test.com", first_name: "Joyce ", last_name: "Walker", display_name: "Joyce  Walker", email: "test91@test.com", password: "test"}).save
  StudentUser.new({id:92 , username: "test92@test.com", first_name: "Larry ", last_name: "Jones", display_name: "Larry  Jones", email: "test92@test.com", password: "test"}).save
  StudentUser.new({id:93 , username: "test93@test.com", first_name: "Sarah ", last_name: "Cox", display_name: "Sarah  Cox", email: "test93@test.com", password: "test"}).save
  StudentUser.new({id:94 , username: "test94@test.com", first_name: "Henry ", last_name: "Jenkins", display_name: "Henry  Jenkins", email: "test94@test.com", password: "test"}).save
  StudentUser.new({id:95 , username: "test95@test.com", first_name: "Julie ", last_name: "Lopez", display_name: "Julie  Lopez", email: "test95@test.com", password: "test"}).save
  StudentUser.new({id:96 , username: "test96@test.com", first_name: "Virginia ", last_name: "James", display_name: "Virginia  James", email: "test96@test.com", password: "test"}).save
  StudentUser.new({id:97 , username: "test97@test.com", first_name: "Lori ", last_name: "Ross", display_name: "Lori  Ross", email: "test97@test.com", password: "test"}).save
  StudentUser.new({id:98 , username: "test98@test.com", first_name: "Joan ", last_name: "Rogers", display_name: "Joan  Rogers", email: "test98@test.com", password: "test"}).save
  StudentUser.new({id:99 , username: "test99@test.com", first_name: "Sara ", last_name: "Martinez", display_name: "Sara  Martinez", email: "test99@test.com", password: "test"}).save
  

  puts 'deleting teacher users'
  TeacherUser.delete_all

  puts 'adding teacher users'
  TeacherUser.new({id:100 , username: "dli@sjusd.org", first_name: "Dennis", last_name: "Li", display_name: "Dennis Li", email: "dli@sjusd.org", password: "test"}).save
  TeacherUser.new({id:101 , username: "rgupta@sjusd.org", first_name: "Rupa", last_name: "Gupta", display_name: "Rupa Gupta", email: "rgupta@sjusd.org", password: "test"}).save


  puts 'deleting activity data'
  Activity.delete_all

  puts 'adding activities'
  Activity.new({id: 1, name:"Multiplication", description: "ThatQuiz", instructions: "90%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 2, name:"Division", description: "ThatQuiz", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 3, name:"Long Division1", description: "ThatQuiz", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 4, name:"Long Division2", description: "ThatQuiz", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 5, name:"Long Division3", description: "ThatQuiz", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 6, name:"Multiplication without carrying", description: "Khan", instructions: "5 in a row", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 7, name:"Multiplication with carrying", description: "Khan", instructions: "5 in a row", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 8, name:"Multiplying 2 digits by 2 digits", description: "Khan", instructions: "5 in a row", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 9, name:"Multi-digit division without remainders", description: "Khan", instructions: "5 in a row", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 10, name:"Division with remainders", description: "Khan", instructions: "5 in a row", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 11, name:"Multiplication and division word problems", description: "Khan", instructions: "5 in a row", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 12, name:"GCF", description: "Khan", instructions: "5 in a row", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 13, name:"L3: Fluently Solve Multiplication Problems", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 14, name:"L3: Fluently Solve Division Problems", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 15, name:"L3: Solving Multiplication and Division Verbally", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 16, name:"L4: Multiplication and Division Strategies", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 17, name:"L4: Factors", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 18, name:"L4: Relating Multiplication and Division", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 19, name:"L5: Multiplication with Multi-Digit Whole Numbers", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 20, name:"L5: Dividing Whole Numbers", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 21, name:"L5: Complete Equivalent Fractions", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 22, name:"L5: Finding Equivalent Fractions and Fractions in Simplest Form", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 23, name:"L6: Identifying the Least Common Multiple", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  Activity.new({id: 24, name:"L6: Identifying the Greatest Common Factor", description: "TenMarks", instructions: "80%+", teacher_user_id: 100, activity_type: "scored"}).save
  
  
  puts 'deleting classrooms'
  Classroom.delete_all

  puts 'adding classrooms'
  Classroom.new({id: 1, teacher_user_id: 100,name: "1st Period Math", classroom_code: "li-1-math"}).save
  Classroom.new({id: 2, teacher_user_id: 100,name: "2nd Period Math", classroom_code: "li-2-math"}).save
  Classroom.new({id: 3, teacher_user_id: 100,name: "3rd Period Math", classroom_code: "li-3-math"}).save
  Classroom.new({id: 4, teacher_user_id: 100,name: "4th Period Math", classroom_code: "li-4-math"}).save

  puts 'deleting classroom activities'
  ActivitiesClassrooms.delete_all

  puts 'adding classroom activities'
  ActivitiesClassrooms.new({activity_id: 1, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 2, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 3, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 4, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 5, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 6, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 7, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 8, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 9, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 10, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 11, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 12, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 13, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 14, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 15, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 16, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 17, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 18, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 19, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 20, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 21, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 22, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 23, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 24, classroom_id: 1}).save
  ActivitiesClassrooms.new({activity_id: 1, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 2, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 3, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 4, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 5, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 6, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 7, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 8, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 9, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 10, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 11, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 12, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 13, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 14, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 15, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 16, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 17, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 18, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 19, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 20, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 21, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 22, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 23, classroom_id: 2}).save
  ActivitiesClassrooms.new({activity_id: 24, classroom_id: 2}).save



  # Other test data should be added here...

  end
end