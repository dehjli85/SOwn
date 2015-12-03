namespace :app do
	task :restore_demo_account => [:environment] do 

		puts "----------------BEFORE DELETION----------------------------------"

		puts "Classroom count: #{Classroom.count}"
		puts "ClassroomStudentUser count: #{ClassroomStudentUser.count}"
		puts "Activity count: #{Activity.count}"
		puts "ActivityTagPairing count: #{ActivityTagPairing.count}"
		puts "ClassroomActivityPairing count: #{ClassroomActivityPairing.count}"
		puts "StudentPerformance count: #{StudentPerformance.count_all}"
		puts "StudentPerformanceVerification count: #{StudentPerformanceVerification.count}"
		puts "ActivityGoal count: #{ActivityGoal.count}"
		puts "ActivityGoalReflection count: #{ActivityGoalReflection.count}"

		teacher_user_id = TeacherUser.where(email: 'rupa@sowntogrow.com').first.id
		control_teacher_user_id = TeacherUser.where(email: 'rverma@sjusd.org').first.id
		
		puts "deleting classrooms..."
		classroom_ids = Classroom.where(teacher_user_id: teacher_user_id).pluck(:id)
		Classroom.delete(classroom_ids)

		puts "deleting students from classrooms..."
		csu_ids = ClassroomStudentUser.where(classroom_id: classroom_ids).pluck(:id)
		ClassroomStudentUser.delete(csu_ids)

		puts "deleting activities..."
		activity_ids = Activity.where(teacher_user_id: teacher_user_id).pluck(:id)
		Activity.delete(activity_ids)

		puts "deleting activity tag pairings..."
		atp_ids = ActivityTagPairing.where(activity_id: activity_ids).pluck(:id)
		ActivityTagPairing.delete(atp_ids)
		
		puts "deleting classroom activities...."
		cap_ids = ClassroomActivityPairing.where(classroom_id: classroom_ids).pluck(:id)
		ClassroomActivityPairing.delete(cap_ids)

		puts "deleting student performances..."
		sp_ids = StudentPerformance.where(classroom_activity_pairing_id: cap_ids).pluck(:id)
		StudentPerformance.delete(sp_ids)

		puts "deleting student performance verifications..."
		spv_ids = StudentPerformanceVerification.where(classroom_activity_pairing_id: cap_ids).pluck(:id)
		StudentPerformanceVerification.delete(spv_ids)

		puts "deleting activity goals..."
		ag_ids = ActivityGoal.where(classroom_activity_pairing_id: cap_ids).pluck(:id)
		ActivityGoal.delete(ag_ids)

		puts "deleting activity goal reflections..."
		agr_ids = ActivityGoalReflection.where(activity_goal_id: ag_ids).pluck(:id)
		ActivityGoalReflection.delete(agr_ids)

		puts "-----------------AFTER DELETION----------------------------------"

		puts "Classroom count: #{Classroom.count}"
		puts "ClassroomStudentUser count: #{ClassroomStudentUser.count}"
		puts "Activity count: #{Activity.count}"
		puts "ActivityTagPairing count: #{ActivityTagPairing.count}"
		puts "ClassroomActivityPairing count: #{ClassroomActivityPairing.count}"
		puts "StudentPerformance count: #{StudentPerformance.count_all}"
		puts "StudentPerformanceVerification count: #{StudentPerformanceVerification.count}"
		puts "ActivityGoal count: #{ActivityGoal.count}"
		puts "ActivityGoalReflection count: #{ActivityGoalReflection.count}"


		puts "adding classrooms data..."
		c1 = Classroom.new({teacher_user_id: teacher_user_id, name: "1st Period Math", classroom_code: "demo-1"})
		c1.save
		c2 = Classroom.new({teacher_user_id: teacher_user_id ,name: "2nd Period Math", classroom_code: "demo-2"})
		c2.save



		puts "adding students to classrooms..."
		ClassroomStudentUser.new({student_user_id: 2, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 3, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 4, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 5, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 6, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 7, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 8, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 9, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 10, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 11, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 12, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 13, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 14, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 15, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 16, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 17, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 18, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 19, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 20, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 21, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 22, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 23, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 24, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 25, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 26, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 27, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 28, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 29, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 29, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 30, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 31, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 32, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 33, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 34, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 35, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 36, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 37, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 38, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 39, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 40, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 41, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 42, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 43, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 44, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 45, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 46, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 47, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 48, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 49, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 50, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 51, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 52, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 53, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 54, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 55, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 56, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 57, classroom_id: c1.id}).save
		ClassroomStudentUser.new({student_user_id: 58, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 59, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 60, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 61, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 62, classroom_id: c2.id}).save
		ClassroomStudentUser.new({student_user_id: 63, classroom_id: c2.id}).save

		# add self to classroom
		self_student = StudentUser.where(email: "rupa@sowntogrow.com").first
		ClassroomStudentUser.new({student_user_id: self_student.id, classroom_id: c1.id}).save		

		puts "adding activities...."
		a1 = Activity.new({name:"(2) Multiplication 1-12", description: "thatquiz link with 100 multiplication questions, numbers 1-12", instructions: "90% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 89,link: "http://www.thatquiz.org/tq/practicetest?rx6aka5wlgr2" })
		a2 = Activity.new({name:"(4) Division 1-12", description: "thatquiz link with 20 division problems, multiples of numbers 1-12", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "http://www.thatquiz.org/tq/practicetest?ry6akacz1dubv" })
		a3 = Activity.new({name:"(3) Multiplication Word problems-facts to 12", description: "IXL practice on multiplication word problems up to 12", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "https://www.ixl.com/math/grade-3/multiplication-word-problems-facts-to-12" })
		a4 = Activity.new({name:"(14) Division (Adaptive)", description: "Mathspace lesson and practice on division", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "https://mathspace.co/teach2/chapter/14818/85/" })
		a5 = Activity.new({name:"(21) Multiplication and Division Word Problems", description: "Khan Academy practice on multiplication and division word problems", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-fourth-grade-math/cc-4th-mult-div-topic/cc-4th-mult-comparing/e/arithmetic_word_problems" })
		a6 = Activity.new({name:"(20) Division with remainders", description: "Khan Academy practice on division problrms with remainders", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-fourth-grade-math/cc-4th-mult-div-topic/cc-4th-division/e/division_2" })
		a7 = Activity.new({name:"(5) Missing Factors-facts to 12", description: "IXL practice on missing factors, up to 12", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "https://www.ixl.com/math/grade-3/missing-factors-facts-to-12" })
		a8 = Activity.new({name:"(6) Missing Factors-facts to 12-word problems", description: "IXL practice on word problems with missing factors up to 12", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "https://www.ixl.com/math/grade-3/missing-factors-facts-to-12-word-problems" })
		a9 = Activity.new({name:"(7) Multiplication without Carrying", description: "Khan Academy practice for multiplying without carrying", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-fourth-grade-math/cc-4th-mult-div-topic/cc-4th-multiplication/e/multiplication_1.5" })
		a10 = Activity.new({name:"(8) Multipication with carrying ", description: "Khan academy oractice for multipication", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-fourth-grade-math/cc-4th-mult-div-topic/cc-4th-multiplication/e/multiplication_2" })
		a11 = Activity.new({name:"(9) Multiplying 2 digits by 2 digits", description: "Khan Academy practice on multiplying 2 digits by 2 digits", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-fourth-grade-math/cc-4th-mult-div-topic/cc-4th-multiplication/e/multiplication_3" })
		a12 = Activity.new({name:"(10) Multiplication (Adaptive)", description: "Mathspace lesson and practice on multiplication", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "https://mathspace.co/study/#!curriculum/88/topic/1301/subtopic/14817/adaptiveworkout/12/14817/chapter/142/" })
		a13 = Activity.new({name:"(11) Squares up to 20", description: "IXL practice on squaring numbers up to 20", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "https://www.ixl.com/math/grade-3/squares-up-to-20" })
		a14 = Activity.new({name:"(15) Long division #1", description: "Thatquiz link on longdivision with 10 questions", instructions: "90% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 60, benchmark2_score: 80,link: "http://www.thatquiz.org/tq/practicetest?rw6akb4zo9r5" })
		a15 = Activity.new({name:"(12) Multiplication input/output tables: find the rule", description: "IXL practice on multiplication input/output tables: find the rule", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "https://www.ixl.com/math/grade-3/multiplication-input-output-tables-find-the-rule" })
		a16 = Activity.new({name:"(16) Long Division #2", description: "thatquiz link with 10 long division questions, no remainders", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "http://www.thatquiz.org/tq/practicetest?rx6akb6xomda" })
		a17 = Activity.new({name:"(17) Long Division #3", description: "thatquiz link with 10 long division questions, no remainders", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "http://www.thatquiz.org/tq/practicetest?rx6akbbytfum" })
		a18 = Activity.new({name:"(18) Multi-digit division without remainders", description: "Khan Academy practice on multi  division problems without remainders", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-fourth-grade-math/cc-4th-mult-div-topic/cc-4th-division/e/division_1.5" })
		a19 = Activity.new({name:"(13) Multiply three or more numbers", description: "IXL practice on multiplying three or more numbers", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 80,link: "https://www.ixl.com/math/grade-4/multiply-three-or-more-numbers-word-problems" })
		a20 = Activity.new({name:"(19) Division with Remainders", description: "Khan Academy practice on division with remainders", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-fourth-grade-math/cc-4th-mult-div-topic/cc-4th-division/e/division_2" })
		a21 = Activity.new({name:"(22) GCF", description: "Khan Academy practice on finding the Greatest Common Factor (GCF)", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-sixth-grade-math/cc-6th-factors-and-multiples/cc-6th-gcf/e/greatest_common_divisor" })
		a22 = Activity.new({name:"(23) GCF and LCM (adaptive)", description: "Mathspace lesson and practice on finding the Greatest Common Factor and Least Common Multiple of numbers", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "https://mathspace.co/teach2/chapter/14823/109/" })
		a23 = Activity.new({name:"(24) Simplifying Fractions", description: "Khan Academy practice on simplifying fractions", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/pre-algebra/fractions-pre-alg/equivalent-fractions-pre-alg/e/simplifying_fractions" })
		a24 = Activity.new({name:"(26) Order of operations", description: "Khan academy practice on order of operations", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/pre-algebra/order-of-operations/order_of_operations/e/order_of_operations_2" })
		a25 = Activity.new({name:"(27) Order of Operations (Adaptive)", description: "Mathspace lesson and practice on order of operations", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 69, benchmark2_score: 79,link: "https://mathspace.co/teach2/chapter/14821/144/" })
		a26 = Activity.new({name:"(25) Equivalent fractions", description: "Khan Academy practice on equivalent fractions", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 2, benchmark2_score: 4,link: "https://www.khanacademy.org/math/pre-algebra/fractions-pre-alg/equivalent-fractions-pre-alg/e/equivalent_fractions" })
		a27 = Activity.new({name:"(28) STAR Test #2-Grade Level Equivalent", description: "This number gives your grade and month equivalent. For example, 4.5 is the same as 4th grade and 5 months. 7.2 is 7th grade with 2 months.", instructions: "6.0 or higher", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 12, benchmark1_score: 2.9, benchmark2_score: 6,link: "" })
		a28 = Activity.new({name:"(20) Long Division (Adaptive)", description: "Mathspace lesson and practice on long division", instructions: "80% correct", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 70, benchmark2_score: 80,link: "https://mathspace.co/teach2/chapter/14820/99/" })
		a29 = Activity.new({name:"(29) One-Step Equations with Multiplication and Division", description: "Khan academy activities for one-step equations with multiplication and division", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 3, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-sixth-grade-math/cc-6th-equations-and-inequalities/cc-6th-one-step-mult-div-equations/e/linear_equations_1" })
		a30 = Activity.new({name:"(30) One-step Equations with Multiplication and Division with Decimals or Fractions", description: "Khan Academy activity on one-step equations with multiplication and division with decimals or fractions", instructions: "5 in a row", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 5, benchmark1_score: 3, benchmark2_score: 4,link: "https://www.khanacademy.org/math/cc-sixth-grade-math/cc-6th-equations-and-inequalities/cc-6th-one-step-mult-div-equations/e/one-step-mult-div-equations-2" })
		a31 = Activity.new({name:"(32) One Step Equation Word Problems", description: "Solve one step equations from word problems on IXL", instructions: "Smart Score of 100", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 70, benchmark2_score: 80,link: "https://www.ixl.com/math/grade-7/solve-equations-word-problems" })
		a32 = Activity.new({name:"(31) One Step Equations", description: "One step equations practice from IXL", instructions: "Smart Score of 100", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 100, benchmark1_score: 70, benchmark2_score: 80,link: "https://www.ixl.com/math/grade-7/solve-one-step-equations" })
		a33 = Activity.new({name:"(1) STAR Test-Grade Level Equivalent", description: "This number gives your grade and month equivalent. For example, 4.5 is the same as 4th grade and 5 months. 7.2 is 7th grade with 2 months.", instructions: "6.0 or higher", teacher_user_id: teacher_user_id, activity_type: "scored", min_score: 0 ,max_score: 12, benchmark1_score: 3, benchmark2_score: 6,link: "" })
		
		a1.save
		a2.save
		a3.save
		a4.save
		a5.save
		a6.save
		a7.save
		a8.save
		a9.save
		a10.save
		a11.save
		a12.save
		a13.save
		a14.save
		a15.save
		a16.save
		a17.save
		a18.save
		a19.save
		a20.save
		a21.save
		a22.save
		a23.save
		a24.save
		a25.save
		a26.save
		a27.save
		a28.save
		a29.save
		a30.save
		a31.save
		a32.save
		a33.save

		puts "adding activity tags..."
		ActivityTagPairing.new({activity_tag_id: 45, activity_id: a21.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a21.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a1.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a2.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a16.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a17.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a14.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a10.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a9.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a11.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a20.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a5.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a5.id }).save
		ActivityTagPairing.new({activity_tag_id: 13, activity_id: a23.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a23.id }).save
		ActivityTagPairing.new({activity_tag_id: 47, activity_id: a23.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a6.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a12.id }).save
		ActivityTagPairing.new({activity_tag_id: 49, activity_id: a12.id }).save
		ActivityTagPairing.new({activity_tag_id: 50, activity_id: a12.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a4.id }).save
		ActivityTagPairing.new({activity_tag_id: 49, activity_id: a4.id }).save
		ActivityTagPairing.new({activity_tag_id: 50, activity_id: a4.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a28.id }).save
		ActivityTagPairing.new({activity_tag_id: 49, activity_id: a28.id }).save
		ActivityTagPairing.new({activity_tag_id: 50, activity_id: a28.id }).save
		ActivityTagPairing.new({activity_tag_id: 49, activity_id: a25.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a25.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a25.id }).save
		ActivityTagPairing.new({activity_tag_id: 52, activity_id: a25.id }).save
		ActivityTagPairing.new({activity_tag_id: 53, activity_id: a25.id }).save
		ActivityTagPairing.new({activity_tag_id: 54, activity_id: a25.id }).save
		ActivityTagPairing.new({activity_tag_id: 50, activity_id: a25.id }).save
		ActivityTagPairing.new({activity_tag_id: 55, activity_id: a25.id }).save
		ActivityTagPairing.new({activity_tag_id: 56, activity_id: a22.id }).save
		ActivityTagPairing.new({activity_tag_id: 45, activity_id: a22.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a22.id }).save
		ActivityTagPairing.new({activity_tag_id: 57, activity_id: a22.id }).save
		ActivityTagPairing.new({activity_tag_id: 58, activity_id: a22.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a22.id }).save
		ActivityTagPairing.new({activity_tag_id: 49, activity_id: a22.id }).save
		ActivityTagPairing.new({activity_tag_id: 50, activity_id: a22.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a3.id }).save
		ActivityTagPairing.new({activity_tag_id: 45, activity_id: a7.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a7.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a7.id }).save
		ActivityTagPairing.new({activity_tag_id: 45, activity_id: a8.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a8.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a8.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a19.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a15.id }).save
		ActivityTagPairing.new({activity_tag_id: 59, activity_id: a13.id }).save
		ActivityTagPairing.new({activity_tag_id: 1, activity_id: a13.id }).save
		ActivityTagPairing.new({activity_tag_id: 61, activity_id: a15.id }).save
		ActivityTagPairing.new({activity_tag_id: 62, activity_id: a33.id }).save
		ActivityTagPairing.new({activity_tag_id: 62, activity_id: a27.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a18.id }).save
		ActivityTagPairing.new({activity_tag_id: 2, activity_id: a26.id }).save
		ActivityTagPairing.new({activity_tag_id: 55, activity_id: a24.id }).save
		ActivityTagPairing.new({activity_tag_id: 86, activity_id: a6.id }).save

		puts "adding classroom activities..."
		cap1 = ClassroomActivityPairing.new({activity_id: a1.id, classroom_id: c2.id, hidden: FALSE, sort_order: 1, archived: FALSE})
		cap2 = ClassroomActivityPairing.new({activity_id: a27.id, classroom_id: c2.id, hidden: FALSE, sort_order: 27, archived: FALSE})
		cap3 = ClassroomActivityPairing.new({activity_id: a33.id, classroom_id: c2.id, hidden: FALSE, sort_order: 0, archived: FALSE})
		cap4 = ClassroomActivityPairing.new({activity_id: a3.id, classroom_id: c2.id, hidden: FALSE, sort_order: 2, archived: FALSE})
		cap5 = ClassroomActivityPairing.new({activity_id: a2.id, classroom_id: c2.id, hidden: FALSE, sort_order: 3, archived: FALSE})
		cap6 = ClassroomActivityPairing.new({activity_id: a33.id, classroom_id: c1.id, hidden: FALSE, sort_order: 0, archived: FALSE})
		cap7 = ClassroomActivityPairing.new({activity_id: a1.id, classroom_id: c1.id, hidden: FALSE, sort_order: 1, archived: FALSE})
		cap8 = ClassroomActivityPairing.new({activity_id: a7.id, classroom_id: c1.id, hidden: FALSE, sort_order: 4, archived: FALSE})
		cap9 = ClassroomActivityPairing.new({activity_id: a9.id, classroom_id: c1.id, hidden: FALSE, sort_order: 6, archived: FALSE})
		cap10 = ClassroomActivityPairing.new({activity_id: a28.id, classroom_id: c1.id, hidden: FALSE, sort_order: 19, archived: FALSE})
		cap11 = ClassroomActivityPairing.new({activity_id: a7.id, classroom_id: c2.id, hidden: FALSE, sort_order: 4, archived: FALSE})
		cap12 = ClassroomActivityPairing.new({activity_id: a8.id, classroom_id: c2.id, hidden: FALSE, sort_order: 5, archived: FALSE})
		cap13 = ClassroomActivityPairing.new({activity_id: a9.id, classroom_id: c2.id, hidden: FALSE, sort_order: 6, archived: FALSE})
		cap14 = ClassroomActivityPairing.new({activity_id: a10.id, classroom_id: c2.id, hidden: FALSE, sort_order: 7, archived: FALSE})
		cap15 = ClassroomActivityPairing.new({activity_id: a11.id, classroom_id: c2.id, hidden: FALSE, sort_order: 8, archived: FALSE})
		cap16 = ClassroomActivityPairing.new({activity_id: a8.id, classroom_id: c1.id, hidden: FALSE, sort_order: 5, archived: FALSE})
		cap17 = ClassroomActivityPairing.new({activity_id: a10.id, classroom_id: c1.id, hidden: FALSE, sort_order: 7, archived: FALSE})
		cap18 = ClassroomActivityPairing.new({activity_id: a15.id, classroom_id: c2.id, hidden: FALSE, sort_order: 11, archived: FALSE})
		cap19 = ClassroomActivityPairing.new({activity_id: a11.id, classroom_id: c1.id, hidden: FALSE, sort_order: 8, archived: FALSE})
		cap20 = ClassroomActivityPairing.new({activity_id: a12.id, classroom_id: c2.id, hidden: FALSE, sort_order: 9, archived: FALSE})
		cap21 = ClassroomActivityPairing.new({activity_id: a13.id, classroom_id: c2.id, hidden: FALSE, sort_order: 10, archived: FALSE})
		cap22 = ClassroomActivityPairing.new({activity_id: a19.id, classroom_id: c2.id, hidden: FALSE, sort_order: 12, archived: FALSE})
		cap23 = ClassroomActivityPairing.new({activity_id: a4.id, classroom_id: c2.id, hidden: FALSE, sort_order: 13, archived: FALSE})
		cap24 = ClassroomActivityPairing.new({activity_id: a14.id, classroom_id: c2.id, hidden: FALSE, sort_order: 14, archived: FALSE})
		cap25 = ClassroomActivityPairing.new({activity_id: a16.id, classroom_id: c2.id, hidden: FALSE, sort_order: 15, archived: FALSE})
		cap26 = ClassroomActivityPairing.new({activity_id: a17.id, classroom_id: c2.id, hidden: FALSE, sort_order: 16, archived: FALSE})
		cap27 = ClassroomActivityPairing.new({activity_id: a18.id, classroom_id: c2.id, hidden: FALSE, sort_order: 17, archived: FALSE})
		cap28 = ClassroomActivityPairing.new({activity_id: a20.id, classroom_id: c2.id, hidden: FALSE, sort_order: 18, archived: FALSE})
		cap29 = ClassroomActivityPairing.new({activity_id: a28.id, classroom_id: c2.id, hidden: FALSE, sort_order: 19, archived: FALSE})
		cap30 = ClassroomActivityPairing.new({activity_id: a5.id, classroom_id: c2.id, hidden: FALSE, sort_order: 20, archived: FALSE})
		cap31 = ClassroomActivityPairing.new({activity_id: a21.id, classroom_id: c2.id, hidden: FALSE, sort_order: 21, archived: FALSE})
		cap32 = ClassroomActivityPairing.new({activity_id: a22.id, classroom_id: c2.id, hidden: FALSE, sort_order: 22, archived: FALSE})
		cap33 = ClassroomActivityPairing.new({activity_id: a23.id, classroom_id: c2.id, hidden: FALSE, sort_order: 23, archived: FALSE})
		cap34 = ClassroomActivityPairing.new({activity_id: a26.id, classroom_id: c2.id, hidden: FALSE, sort_order: 24, archived: FALSE})
		cap35 = ClassroomActivityPairing.new({activity_id: a24.id, classroom_id: c2.id, hidden: FALSE, sort_order: 25, archived: FALSE})
		cap36 = ClassroomActivityPairing.new({activity_id: a25.id, classroom_id: c2.id, hidden: FALSE, sort_order: 26, archived: FALSE})
		cap37 = ClassroomActivityPairing.new({activity_id: a12.id, classroom_id: c1.id, hidden: FALSE, sort_order: 9, archived: FALSE})
		cap38 = ClassroomActivityPairing.new({activity_id: a13.id, classroom_id: c1.id, hidden: FALSE, sort_order: 10, archived: FALSE})
		cap39 = ClassroomActivityPairing.new({activity_id: a15.id, classroom_id: c1.id, hidden: FALSE, sort_order: 11, archived: FALSE})
		cap40 = ClassroomActivityPairing.new({activity_id: a19.id, classroom_id: c1.id, hidden: FALSE, sort_order: 12, archived: FALSE})
		cap41 = ClassroomActivityPairing.new({activity_id: a4.id, classroom_id: c1.id, hidden: FALSE, sort_order: 13, archived: FALSE})
		cap42 = ClassroomActivityPairing.new({activity_id: a3.id, classroom_id: c1.id, hidden: FALSE, sort_order: 2, archived: FALSE})
		cap43 = ClassroomActivityPairing.new({activity_id: a2.id, classroom_id: c1.id, hidden: FALSE, sort_order: 3, archived: FALSE})
		cap44 = ClassroomActivityPairing.new({activity_id: a14.id, classroom_id: c1.id, hidden: FALSE, sort_order: 14, archived: FALSE})
		cap45 = ClassroomActivityPairing.new({activity_id: a16.id, classroom_id: c1.id, hidden: FALSE, sort_order: 15, archived: FALSE})
		cap46 = ClassroomActivityPairing.new({activity_id: a17.id, classroom_id: c1.id, hidden: FALSE, sort_order: 16, archived: FALSE})
		cap47 = ClassroomActivityPairing.new({activity_id: a18.id, classroom_id: c1.id, hidden: FALSE, sort_order: 17, archived: FALSE})
		cap48 = ClassroomActivityPairing.new({activity_id: a20.id, classroom_id: c1.id, hidden: FALSE, sort_order: 18, archived: FALSE})
		cap49 = ClassroomActivityPairing.new({activity_id: a5.id, classroom_id: c1.id, hidden: FALSE, sort_order: 20, archived: FALSE})
		cap50 = ClassroomActivityPairing.new({activity_id: a21.id, classroom_id: c1.id, hidden: FALSE, sort_order: 21, archived: FALSE})
		cap51 = ClassroomActivityPairing.new({activity_id: a22.id, classroom_id: c1.id, hidden: FALSE, sort_order: 22, archived: FALSE})
		cap52 = ClassroomActivityPairing.new({activity_id: a23.id, classroom_id: c1.id, hidden: FALSE, sort_order: 23, archived: FALSE})
		cap53 = ClassroomActivityPairing.new({activity_id: a26.id, classroom_id: c1.id, hidden: FALSE, sort_order: 24, archived: FALSE})
		cap54 = ClassroomActivityPairing.new({activity_id: a24.id, classroom_id: c1.id, hidden: FALSE, sort_order: 25, archived: FALSE})
		cap55 = ClassroomActivityPairing.new({activity_id: a25.id, classroom_id: c1.id, hidden: FALSE, sort_order: 26, archived: FALSE})
		cap56 = ClassroomActivityPairing.new({activity_id: a27.id, classroom_id: c1.id, hidden: FALSE, sort_order: 27, archived: FALSE})
		cap57 = ClassroomActivityPairing.new({activity_id: a29.id, classroom_id: c1.id, hidden: FALSE, sort_order: 28, archived: FALSE})
		cap58 = ClassroomActivityPairing.new({activity_id: a29.id, classroom_id: c2.id, hidden: FALSE, sort_order: 28, archived: FALSE})
		cap59 = ClassroomActivityPairing.new({activity_id: a30.id, classroom_id: c1.id, hidden: FALSE, sort_order: 29, archived: FALSE})
		cap60 = ClassroomActivityPairing.new({activity_id: a30.id, classroom_id: c2.id, hidden: FALSE, sort_order: 29, archived: FALSE})
		cap61 = ClassroomActivityPairing.new({activity_id: a32.id, classroom_id: c1.id, hidden: FALSE, sort_order: 30, archived: FALSE})
		cap62 = ClassroomActivityPairing.new({activity_id: a32.id, classroom_id: c2.id, hidden: FALSE, sort_order: 30, archived: FALSE})
		cap63 = ClassroomActivityPairing.new({activity_id: a31.id, classroom_id: c1.id, hidden: FALSE, sort_order: 31, archived: FALSE})
		cap64 = ClassroomActivityPairing.new({activity_id: a31.id, classroom_id: c2.id, hidden: FALSE, sort_order: 31, archived: FALSE})
		
		cap1.save
		cap2.save
		cap3.save
		cap4.save
		cap5.save
		cap6.save
		cap7.save
		cap8.save
		cap9.save
		cap10.save
		cap11.save
		cap12.save
		cap13.save
		cap14.save
		cap15.save
		cap16.save
		cap17.save
		cap18.save
		cap19.save
		cap20.save
		cap21.save
		cap22.save
		cap23.save
		cap24.save
		cap25.save
		cap26.save
		cap27.save
		cap28.save
		cap29.save
		cap30.save
		cap31.save
		cap32.save
		cap33.save
		cap34.save
		cap35.save
		cap36.save
		cap37.save
		cap38.save
		cap39.save
		cap40.save
		cap41.save
		cap42.save
		cap43.save
		cap44.save
		cap45.save
		cap46.save
		cap47.save
		cap48.save
		cap49.save
		cap50.save
		cap51.save
		cap52.save
		cap53.save
		cap54.save
		cap55.save
		cap56.save
		cap57.save
		cap58.save
		cap59.save
		cap60.save
		cap61.save
		cap62.save
		cap63.save
		cap64.save

		puts "adding student performances..."
		StudentPerformance.new({student_user_id: 2, classroom_activity_pairing_id: cap7.id ,scored_performance: 16, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 2, classroom_activity_pairing_id: cap7.id ,scored_performance: 10, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 2, classroom_activity_pairing_id: cap6.id ,scored_performance: 3.1, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap1.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap5.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap3.id ,scored_performance: 2.9, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 3, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap1.id ,scored_performance: 76, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap1.id ,scored_performance: 93, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap4.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap11.id ,scored_performance: 91, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap12.id ,scored_performance: 83, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.3, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap18.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap22.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap20.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap24.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap25.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap26.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap28.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 4, classroom_activity_pairing_id: cap30.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 5, classroom_activity_pairing_id: cap7.id ,scored_performance: 25, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 5, classroom_activity_pairing_id: cap7.id ,scored_performance: 27, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 5, classroom_activity_pairing_id: cap6.id ,scored_performance: 3.6, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 5, classroom_activity_pairing_id: cap7.id ,scored_performance: 8, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 5, classroom_activity_pairing_id: cap7.id ,scored_performance: 55, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 6, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.6, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 6, classroom_activity_pairing_id: cap7.id ,scored_performance: 40, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 6, classroom_activity_pairing_id: cap7.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 6, classroom_activity_pairing_id: cap56.id ,scored_performance: 6.3, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap7.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap7.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap7.id ,scored_performance: 91, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap43.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap6.id ,scored_performance: 3.2, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap43.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap43.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap37.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap40.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap41.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 7, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap1.id ,scored_performance: 67, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap1.id ,scored_performance: 86, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap1.id ,scored_performance: 89, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap1.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap5.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap3.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap3.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/03"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/04"}).save
		StudentPerformance.new({student_user_id: 8, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/04"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 67, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 63, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 53, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 40, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 61, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 63, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 61, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 59, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 23, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap3.id ,scored_performance: 4.1, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 59, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 60, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 60, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 48, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 60, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 48, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 77, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 76, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap5.id ,scored_performance: 35, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap1.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap5.id ,scored_performance: 55, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap11.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 9, classroom_activity_pairing_id: cap5.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/11/03"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 22, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 48, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 27, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 40, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 35, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 37, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 46, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 46, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 79, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 43, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 44, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap3.id ,scored_performance: 3, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 36, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 44, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 65, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 62, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 64, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 45, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 62, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 86, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 83, completed_performance: nil, performance_date: "2015/11/03"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 76, completed_performance: nil, performance_date: "2015/11/03"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 99, completed_performance: nil, performance_date: "2015/11/03"}).save
		StudentPerformance.new({student_user_id: 10, classroom_activity_pairing_id: cap1.id ,scored_performance: 79, completed_performance: nil, performance_date: "2015/11/04"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap1.id ,scored_performance: 96, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.9, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap4.id ,scored_performance: 97, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 11, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap1.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap5.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap22.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap24.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap25.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap26.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap27.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap28.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap30.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.1, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap31.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap32.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap33.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap20.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 12, classroom_activity_pairing_id: cap23.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap1.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap5.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap2.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap3.id ,scored_performance: 4.9, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap11.id ,scored_performance: 97, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap12.id ,scored_performance: 97, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 13, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap1.id ,scored_performance: 83, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap1.id ,scored_performance: 98, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap20.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap24.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap25.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap26.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 14, classroom_activity_pairing_id: cap28.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap1.id ,scored_performance: 97, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap4.id ,scored_performance: 96, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap3.id ,scored_performance: 4.1, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap2.id ,scored_performance: 5.3, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 15, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap1.id ,scored_performance: 99, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap5.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.3, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap22.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap24.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap25.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap26.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap28.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 16, classroom_activity_pairing_id: cap30.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap1.id ,scored_performance: 62, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap1.id ,scored_performance: 69, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap1.id ,scored_performance: 79, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap1.id ,scored_performance: 93, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap5.id ,scored_performance: 45, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap3.id ,scored_performance: 3.9, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap5.id ,scored_performance: 50, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap5.id ,scored_performance: 64, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap5.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap5.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap5.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/03"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/03"}).save
		StudentPerformance.new({student_user_id: 17, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/04"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap1.id ,scored_performance: 89, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap1.id ,scored_performance: 98, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap5.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap11.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.9, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap20.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap24.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap25.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap26.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 18, classroom_activity_pairing_id: cap28.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap7.id ,scored_performance: 97, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap43.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap6.id ,scored_performance: 7, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap37.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap41.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap46.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap47.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap48.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap49.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 19, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/29"}).save
		StudentPerformance.new({student_user_id: 20, classroom_activity_pairing_id: cap6.id ,scored_performance: 1.8, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 20, classroom_activity_pairing_id: cap7.id ,scored_performance: 1, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 20, classroom_activity_pairing_id: cap7.id ,scored_performance: 3, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 20, classroom_activity_pairing_id: cap7.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 20, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 20, classroom_activity_pairing_id: cap42.id ,scored_performance: 0, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 21, classroom_activity_pairing_id: cap7.id ,scored_performance: 18, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 21, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.3, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 21, classroom_activity_pairing_id: cap7.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 21, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 21, classroom_activity_pairing_id: cap43.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 21, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 21, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 21, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 21, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap6.id ,scored_performance: 3.7, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap7.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap42.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap56.id ,scored_performance: 5.3, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap43.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap7.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap43.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap8.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap16.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap37.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 22, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap43.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.7, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap7.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap43.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.6, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap56.id ,scored_performance: 4.6, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap17.id ,scored_performance: 3, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap17.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 23, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 24, classroom_activity_pairing_id: cap7.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 24, classroom_activity_pairing_id: cap6.id ,scored_performance: 5.1, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 24, classroom_activity_pairing_id: cap42.id ,scored_performance: 82, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 24, classroom_activity_pairing_id: cap56.id ,scored_performance: 4.6, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 24, classroom_activity_pairing_id: cap38.id ,scored_performance: 91.8, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap7.id ,scored_performance: 98, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap43.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap7.id ,scored_performance: 97, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap43.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap6.id ,scored_performance: 5.8, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap43.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap7.id ,scored_performance: 99, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap42.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap42.id ,scored_performance: 96, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap56.id ,scored_performance: 6.2, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap8.id ,scored_performance: 96.8, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap16.id ,scored_performance: 96, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap16.id ,scored_performance: 96, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap19.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap46.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap46.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 25, classroom_activity_pairing_id: cap46.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap7.id ,scored_performance: 69, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap7.id ,scored_performance: 99, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.2, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap7.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap43.id ,scored_performance: 60, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap43.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap56.id ,scored_performance: 5.1, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap43.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap42.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap43.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap16.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap19.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap37.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap38.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap40.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap47.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap48.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap46.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap49.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 26, classroom_activity_pairing_id: cap41.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap7.id ,scored_performance: 86, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap43.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap6.id ,scored_performance: 5.7, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap53.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap56.id ,scored_performance: 5.9, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap39.id ,scored_performance: 93.9, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap40.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap41.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap37.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap46.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap47.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap48.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 27, classroom_activity_pairing_id: cap49.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 28, classroom_activity_pairing_id: cap7.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 28, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 28, classroom_activity_pairing_id: cap43.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 28, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 28, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 28, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.7, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 28, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 28, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 28, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap7.id ,scored_performance: 26, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap7.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap6.id ,scored_performance: 6.1, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap43.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap37.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap40.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap41.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap53.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap50.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap47.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap51.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap48.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap48.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap48.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap52.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap46.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap49.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap49.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap54.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap55.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap7.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap43.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap9.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap6.id ,scored_performance: 7.6, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap37.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap43.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap56.id ,scored_performance: 6.7, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap40.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap41.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap46.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap49.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap47.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap48.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap7.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap50.id ,scored_performance: 1.5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap50.id ,scored_performance: 1.5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap50.id ,scored_performance: 1.5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap50.id ,scored_performance: 1.5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 29, classroom_activity_pairing_id: cap50.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap7.id ,scored_performance: 52, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap6.id ,scored_performance: 6.7, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap7.id ,scored_performance: 86, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap7.id ,scored_performance: 59, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap7.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap43.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap56.id ,scored_performance: 6.3, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap46.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap17.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap7.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap37.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap40.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap41.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 30, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap6.id ,scored_performance: 2.9, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap7.id ,scored_performance: 2.9, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap7.id ,scored_performance: 14, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap56.id ,scored_performance: 1.8, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap7.id ,scored_performance: 75, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap7.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap43.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap42.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap8.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap37.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap38.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap39.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap40.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap41.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 31, classroom_activity_pairing_id: cap44.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap7.id ,scored_performance: 69, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.8, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap7.id ,scored_performance: 77, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap7.id ,scored_performance: 93, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap56.id ,scored_performance: 5.4, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap19.id ,scored_performance: 3, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 32, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 33, classroom_activity_pairing_id: cap7.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 33, classroom_activity_pairing_id: cap7.id ,scored_performance: 7, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 33, classroom_activity_pairing_id: cap56.id ,scored_performance: 3.3, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 33, classroom_activity_pairing_id: cap6.id ,scored_performance: 2.7, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 33, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 33, classroom_activity_pairing_id: cap43.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap7.id ,scored_performance: 13, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap6.id ,scored_performance: 5.6, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap7.id ,scored_performance: 42, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap7.id ,scored_performance: 50, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap42.id ,scored_performance: 96.8, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap42.id ,scored_performance: 90.5999999999998, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap43.id ,scored_performance: 35, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap43.id ,scored_performance: 75, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 34, classroom_activity_pairing_id: cap43.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap7.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap6.id ,scored_performance: 5.1, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap7.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap44.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap42.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap56.id ,scored_performance: 5.2, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap56.id ,scored_performance: 5.2, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap43.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap8.id ,scored_performance: 82, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap16.id ,scored_performance: 96, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap17.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap19.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap37.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 35, classroom_activity_pairing_id: cap40.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap1.id ,scored_performance: 91, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap4.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap5.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap5.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap11.id ,scored_performance: 96, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.6, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap1.id ,scored_performance: 99, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap20.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 36, classroom_activity_pairing_id: cap24.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap25.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap1.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap3.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap5.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap4.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap2.id ,scored_performance: 5.6, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap26.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap11.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap12.id ,scored_performance: 74, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap13.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap15.id ,scored_performance: 3, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap20.id ,scored_performance: 50, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap21.id ,scored_performance: 77, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap21.id ,scored_performance: 77, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap18.id ,scored_performance: 65, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap21.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap20.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap15.id ,scored_performance: 4.2, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap13.id ,scored_performance: 4.9, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap22.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap22.id ,scored_performance: 82, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap23.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 37, classroom_activity_pairing_id: cap24.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 38, classroom_activity_pairing_id: cap4.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 38, classroom_activity_pairing_id: cap1.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 38, classroom_activity_pairing_id: cap3.id ,scored_performance: 4.8, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 38, classroom_activity_pairing_id: cap5.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 38, classroom_activity_pairing_id: cap5.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 38, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 38, classroom_activity_pairing_id: cap12.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 38, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 38, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap5.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap1.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap12.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap2.id ,scored_performance: 5.9, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.3, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap14.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.8, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 39, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap26.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap1.id ,scored_performance: 96, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap4.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap11.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap13.id ,scored_performance: 4.75, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap15.id ,scored_performance: 2.5, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap20.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap21.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.7, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap2.id ,scored_performance: 5.5, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap24.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 40, classroom_activity_pairing_id: cap25.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap1.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap4.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap11.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap12.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap3.id ,scored_performance: 6.7, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap21.id ,scored_performance: 91, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap2.id ,scored_performance: 6, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap18.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap24.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap25.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap26.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 41, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap1.id ,scored_performance: 55, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap3.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap1.id ,scored_performance: 93, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap2.id ,scored_performance: 4.4, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap5.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 42, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap22.id ,scored_performance: 96, completed_performance: nil, performance_date: "2015/09/23"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap1.id ,scored_performance: 98, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap4.id ,scored_performance: 96.5, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap5.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/09/01"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap11.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap12.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap13.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap3.id ,scored_performance: 7, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap3.id ,scored_performance: 7.1, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap2.id ,scored_performance: 9, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap30.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap20.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap23.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap24.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap24.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap25.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap26.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap28.id ,scored_performance: 3.9, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 43, classroom_activity_pairing_id: cap28.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap1.id ,scored_performance: 99, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.4, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap20.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 44, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap1.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap4.id ,scored_performance: 17, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap5.id ,scored_performance: 16, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap5.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap3.id ,scored_performance: 4.6, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap1.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap35.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap2.id ,scored_performance: 4.3, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap25.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap26.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 45, classroom_activity_pairing_id: cap24.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 46, classroom_activity_pairing_id: cap1.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 46, classroom_activity_pairing_id: cap3.id ,scored_performance: 2.7, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 46, classroom_activity_pairing_id: cap4.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 46, classroom_activity_pairing_id: cap5.id ,scored_performance: 10, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 46, classroom_activity_pairing_id: cap5.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap1.id ,scored_performance: 25, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap1.id ,scored_performance: 38, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap1.id ,scored_performance: 21, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap3.id ,scored_performance: 4.4, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap1.id ,scored_performance: 79, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap2.id ,scored_performance: 4.6, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 47, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.5, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap1.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap11.id ,scored_performance: 98, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 48, classroom_activity_pairing_id: cap18.id ,scored_performance: 99, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap1.id ,scored_performance: 54, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap1.id ,scored_performance: 79, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.4, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap1.id ,scored_performance: 93, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap2.id ,scored_performance: 5.9, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap20.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap4.id ,scored_performance: 94, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap5.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 49, classroom_activity_pairing_id: cap20.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/09/22"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap7.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/02"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap7.id ,scored_performance: 29, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap6.id ,scored_performance: 3.2, completed_performance: nil, performance_date: "2015/09/03"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap7.id ,scored_performance: 31, completed_performance: nil, performance_date: "2015/09/08"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap7.id ,scored_performance: 84, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/10"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap6.id ,scored_performance: 3.2, completed_performance: nil, performance_date: "2015/09/24"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap43.id ,scored_performance: 18, completed_performance: nil, performance_date: "2015/09/14"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap8.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/15"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap7.id ,scored_performance: 89, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap43.id ,scored_performance: 30, completed_performance: nil, performance_date: "2015/09/16"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/09/17"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 50, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/09/21"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap7.id ,scored_performance: 86, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap7.id ,scored_performance: 87, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap7.id ,scored_performance: 89, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap7.id ,scored_performance: 84, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap7.id ,scored_performance: 91, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap43.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap6.id ,scored_performance: 6.4, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap48.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap48.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap48.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap8.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap37.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap50.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap51.id ,scored_performance: 76, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap44.id ,scored_performance: 1, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap49.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap44.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap45.id ,scored_performance: 10, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap45.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap52.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap40.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap41.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/29"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap51.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/29"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap53.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/29"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap47.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/29"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap46.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/29"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap54.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 51, classroom_activity_pairing_id: cap57.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap7.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap43.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap19.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.4, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap37.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap38.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap41.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap44.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap45.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap46.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap47.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap48.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap49.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap50.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap51.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap40.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap53.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap52.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 52, classroom_activity_pairing_id: cap54.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap7.id ,scored_performance: 46, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap7.id ,scored_performance: 73, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap7.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap7.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap42.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.8, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap43.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap37.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/10/16"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap47.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/16"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap38.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/10/17"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap44.id ,scored_performance: 81, completed_performance: nil, performance_date: "2015/10/17"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap45.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap46.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap50.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap48.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap49.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap52.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap53.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap54.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap55.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap8.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap16.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap39.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap41.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap41.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap40.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap51.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 53, classroom_activity_pairing_id: cap57.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 54, classroom_activity_pairing_id: cap7.id ,scored_performance: 27, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 54, classroom_activity_pairing_id: cap6.id ,scored_performance: 5.1, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 54, classroom_activity_pairing_id: cap7.id ,scored_performance: 40, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 54, classroom_activity_pairing_id: cap7.id ,scored_performance: 68, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 54, classroom_activity_pairing_id: cap7.id ,scored_performance: 79, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 54, classroom_activity_pairing_id: cap7.id ,scored_performance: 97, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 54, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/29"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 13, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 24, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 39, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 37, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 26, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 29, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap6.id ,scored_performance: 3.8, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 20, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 12, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 28, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 48, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 43, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 16, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 23, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 19, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 14, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 25, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 64, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 55, classroom_activity_pairing_id: cap7.id ,scored_performance: 45, completed_performance: nil, performance_date: "2015/10/29"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 19, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 27, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 17, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 16, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap6.id ,scored_performance: 2.8, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 26, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 21, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 22, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 30, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 18, completed_performance: nil, performance_date: "2015/10/29"}).save
		StudentPerformance.new({student_user_id: 56, classroom_activity_pairing_id: cap7.id ,scored_performance: 44, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap7.id ,scored_performance: 91, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap43.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap9.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap17.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.9, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap19.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap37.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap38.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap42.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap8.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap16.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 57, classroom_activity_pairing_id: cap39.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 58, classroom_activity_pairing_id: cap1.id ,scored_performance: 56, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 58, classroom_activity_pairing_id: cap1.id ,scored_performance: 83, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap1.id ,scored_performance: 89, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap1.id ,scored_performance: 98, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap5.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap24.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap25.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap26.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap28.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap30.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.1, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap31.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap32.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 59, classroom_activity_pairing_id: cap33.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap1.id ,scored_performance: 97, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap4.id ,scored_performance: 99, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap5.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap24.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap25.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap26.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap28.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap30.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap3.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap31.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap33.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 60, classroom_activity_pairing_id: cap35.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/11/03"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap1.id ,scored_performance: 57, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap1.id ,scored_performance: 72, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap1.id ,scored_performance: 72, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap1.id ,scored_performance: 89, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap1.id ,scored_performance: 86, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap1.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap5.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap3.id ,scored_performance: 5.8, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap20.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap23.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap23.id ,scored_performance: 76, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap23.id ,scored_performance: 80, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap24.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap25.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap26.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap27.id ,scored_performance: 4, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap28.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/26"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap21.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap18.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap18.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap18.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 61, classroom_activity_pairing_id: cap22.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/11/02"}).save
		StudentPerformance.new({student_user_id: 62, classroom_activity_pairing_id: cap1.id ,scored_performance: 6, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 62, classroom_activity_pairing_id: cap1.id ,scored_performance: 28, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 62, classroom_activity_pairing_id: cap1.id ,scored_performance: 19, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 62, classroom_activity_pairing_id: cap1.id ,scored_performance: 25, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 62, classroom_activity_pairing_id: cap1.id ,scored_performance: 32, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 62, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 62, classroom_activity_pairing_id: cap3.id ,scored_performance: 2.5, completed_performance: nil, performance_date: "2015/10/20"}).save
		StudentPerformance.new({student_user_id: 62, classroom_activity_pairing_id: cap1.id ,scored_performance: 46, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 62, classroom_activity_pairing_id: cap1.id ,scored_performance: 50, completed_performance: nil, performance_date: "2015/10/28"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap1.id ,scored_performance: 92, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap4.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/13"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap5.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/14"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap13.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap14.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/15"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap15.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/19"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap24.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap25.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/10/21"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap26.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap27.id ,scored_performance: 5, completed_performance: nil, performance_date: "2015/10/22"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap11.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/27"}).save
		StudentPerformance.new({student_user_id: 63, classroom_activity_pairing_id: cap12.id ,scored_performance: 100, completed_performance: nil, performance_date: "2015/10/28"}).save

		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap6.id ,scored_performance: 4.5, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap7.id ,scored_performance: 55, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap7.id ,scored_performance: 75, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap7.id ,scored_performance: 95, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap42.id ,scored_performance: 70, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap42.id ,scored_performance: 90, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap43.id ,scored_performance: 85, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap8.id ,scored_performance: 65, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap8.id ,scored_performance: 75, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap16.id ,scored_performance: 65, completed_performance: nil, performance_date: "2015/11/13"}).save
		StudentPerformance.new({student_user_id: self_student.id, classroom_activity_pairing_id: cap9.id ,scored_performance: 3, completed_performance: nil, performance_date: "2015/11/13"}).save
		puts "adding student performance verifications..."
		puts "NO STUDENT VERIFICATIONS ADDED"

		puts "adding activity goals..."
		ag1 = ActivityGoal.new({classroom_activity_pairing_id: cap20.id ,student_user_id: 3, score_goal: 100, goal_date: "2015/10/27"})
		ag2 = ActivityGoal.new({classroom_activity_pairing_id: cap2.id ,student_user_id: 3, score_goal: 8, goal_date: "2015/11/04"})
		ag3 = ActivityGoal.new({classroom_activity_pairing_id: cap2.id ,student_user_id: 4, score_goal: 8, goal_date: "2015/11/04"})
		ag4 = ActivityGoal.new({classroom_activity_pairing_id: cap7.id ,student_user_id: 5, score_goal: 80, goal_date: "2015/10/27"})
		ag5 = ActivityGoal.new({classroom_activity_pairing_id: cap17.id ,student_user_id: 7, score_goal: 5, goal_date: "2015/10/27"})
		ag6 = ActivityGoal.new({classroom_activity_pairing_id: cap19.id ,student_user_id: 7, score_goal: 5, goal_date: "2015/10/27"})
		ag7 = ActivityGoal.new({classroom_activity_pairing_id: cap37.id ,student_user_id: 7, score_goal: 100, goal_date: "2015/10/27"})
		ag8 = ActivityGoal.new({classroom_activity_pairing_id: cap38.id ,student_user_id: 7, score_goal: 100, goal_date: "2015/10/28"})
		ag9 = ActivityGoal.new({classroom_activity_pairing_id: cap39.id ,student_user_id: 7, score_goal: 100, goal_date: "2015/10/28"})
		ag10 = ActivityGoal.new({classroom_activity_pairing_id: cap40.id ,student_user_id: 7, score_goal: 100, goal_date: "2015/11/02"})
		ag11 = ActivityGoal.new({classroom_activity_pairing_id: cap44.id ,student_user_id: 7, score_goal: 90, goal_date: "2015/11/02"})
		ag12 = ActivityGoal.new({classroom_activity_pairing_id: cap15.id ,student_user_id: 8, score_goal: 5, goal_date: "2015/11/03"})
		ag13 = ActivityGoal.new({classroom_activity_pairing_id: cap2.id ,student_user_id: 8, score_goal: 8, goal_date: "2015/11/04"})
		ag14 = ActivityGoal.new({classroom_activity_pairing_id: cap1.id ,student_user_id: 9, score_goal: 80, goal_date: "2015/10/27"})
		ag15 = ActivityGoal.new({classroom_activity_pairing_id: cap4.id ,student_user_id: 9, score_goal: 80, goal_date: "2015/10/31"})
		ag16 = ActivityGoal.new({classroom_activity_pairing_id: cap11.id ,student_user_id: 9, score_goal: 90, goal_date: "2015/11/04"})
		ag17 = ActivityGoal.new({classroom_activity_pairing_id: cap12.id ,student_user_id: 9, score_goal: 90, goal_date: "2015/11/30"})
		ag18 = ActivityGoal.new({classroom_activity_pairing_id: cap5.id ,student_user_id: 9, score_goal: 80, goal_date: "2015/11/30"})
		ag19 = ActivityGoal.new({classroom_activity_pairing_id: cap2.id ,student_user_id: 9, score_goal: 10, goal_date: "2015/11/10"})
		ag20 = ActivityGoal.new({classroom_activity_pairing_id: cap1.id ,student_user_id: 10, score_goal: 80, goal_date: "2015/10/31"})
		ag21 = ActivityGoal.new({classroom_activity_pairing_id: cap33.id ,student_user_id: 12, score_goal: 5, goal_date: "2015/10/28"})
		ag22 = ActivityGoal.new({classroom_activity_pairing_id: cap20.id ,student_user_id: 12, score_goal: 90, goal_date: "2015/10/29"})
		ag23 = ActivityGoal.new({classroom_activity_pairing_id: cap27.id ,student_user_id: 12, score_goal: 5, goal_date: "2015/11/03"})
		ag24 = ActivityGoal.new({classroom_activity_pairing_id: cap3.id ,student_user_id: 14, score_goal: 7, goal_date: "2015/11/04"})
		ag25 = ActivityGoal.new({classroom_activity_pairing_id: cap22.id ,student_user_id: 16, score_goal: 90, goal_date: "nil"})
		ag26 = ActivityGoal.new({classroom_activity_pairing_id: cap23.id ,student_user_id: 16, score_goal: 90, goal_date: "nil"})
		ag27 = ActivityGoal.new({classroom_activity_pairing_id: cap24.id ,student_user_id: 16, score_goal: 90, goal_date: "nil"})
		ag28 = ActivityGoal.new({classroom_activity_pairing_id: cap25.id ,student_user_id: 16, score_goal: 90, goal_date: "nil"})
		ag29 = ActivityGoal.new({classroom_activity_pairing_id: cap26.id ,student_user_id: 16, score_goal: 90, goal_date: "nil"})
		ag30 = ActivityGoal.new({classroom_activity_pairing_id: cap27.id ,student_user_id: 16, score_goal: 4, goal_date: "nil"})
		ag31 = ActivityGoal.new({classroom_activity_pairing_id: cap28.id ,student_user_id: 16, score_goal: 4, goal_date: "2015/10/28"})
		ag32 = ActivityGoal.new({classroom_activity_pairing_id: cap30.id ,student_user_id: 16, score_goal: 4, goal_date: "nil"})
		ag33 = ActivityGoal.new({classroom_activity_pairing_id: cap31.id ,student_user_id: 16, score_goal: 4, goal_date: "nil"})
		ag34 = ActivityGoal.new({classroom_activity_pairing_id: cap2.id ,student_user_id: 16, score_goal: 7, goal_date: "nil"})
		ag35 = ActivityGoal.new({classroom_activity_pairing_id: cap5.id ,student_user_id: 17, score_goal: 79, goal_date: "2015/10/28"})
		ag36 = ActivityGoal.new({classroom_activity_pairing_id: cap11.id ,student_user_id: 17, score_goal: 80, goal_date: "2015/10/28"})
		ag37 = ActivityGoal.new({classroom_activity_pairing_id: cap12.id ,student_user_id: 17, score_goal: 100, goal_date: "2015/10/28"})
		ag38 = ActivityGoal.new({classroom_activity_pairing_id: cap13.id ,student_user_id: 17, score_goal: 5, goal_date: "2015/10/28"})
		ag39 = ActivityGoal.new({classroom_activity_pairing_id: cap14.id ,student_user_id: 17, score_goal: 5, goal_date: "2015/11/02"})
		ag40 = ActivityGoal.new({classroom_activity_pairing_id: cap15.id ,student_user_id: 17, score_goal: 5, goal_date: "2015/11/02"})
		ag41 = ActivityGoal.new({classroom_activity_pairing_id: cap21.id ,student_user_id: 17, score_goal: 100, goal_date: "2015/11/03"})
		ag42 = ActivityGoal.new({classroom_activity_pairing_id: cap2.id ,student_user_id: 17, score_goal: 7, goal_date: "2015/11/04"})
		ag43 = ActivityGoal.new({classroom_activity_pairing_id: cap18.id ,student_user_id: 17, score_goal: 100, goal_date: "2015/11/04"})
		ag44 = ActivityGoal.new({classroom_activity_pairing_id: cap22.id ,student_user_id: 17, score_goal: 100, goal_date: "2015/11/04"})
		ag45 = ActivityGoal.new({classroom_activity_pairing_id: cap2.id ,student_user_id: 18, score_goal: 6, goal_date: "nil"})
		ag46 = ActivityGoal.new({classroom_activity_pairing_id: cap50.id ,student_user_id: 19, score_goal: 4, goal_date: "2015/10/27"})
		ag47 = ActivityGoal.new({classroom_activity_pairing_id: cap42.id ,student_user_id: 19, score_goal: 90, goal_date: "2015/10/28"})
		ag48 = ActivityGoal.new({classroom_activity_pairing_id: cap38.id ,student_user_id: 19, score_goal: 90, goal_date: "2015/10/28"})
		ag49 = ActivityGoal.new({classroom_activity_pairing_id: cap39.id ,student_user_id: 19, score_goal: 100, goal_date: "2015/10/28"})
		ag50 = ActivityGoal.new({classroom_activity_pairing_id: cap16.id ,student_user_id: 19, score_goal: 90, goal_date: "2015/10/29"})
		ag51 = ActivityGoal.new({classroom_activity_pairing_id: cap8.id ,student_user_id: 19, score_goal: 90, goal_date: "2015/10/29"})
		ag52 = ActivityGoal.new({classroom_activity_pairing_id: cap43.id ,student_user_id: 19, score_goal: 100, goal_date: "2015/11/06"})
		ag53 = ActivityGoal.new({classroom_activity_pairing_id: cap51.id ,student_user_id: 51, score_goal: 89, goal_date: "2015/10/30"})
		ag54 = ActivityGoal.new({classroom_activity_pairing_id: cap7.id ,student_user_id: 51, score_goal: 90, goal_date: "nil"})
		ag55 = ActivityGoal.new({classroom_activity_pairing_id: cap6.id ,student_user_id: 51, score_goal: 6, goal_date: "nil"})
		ag56 = ActivityGoal.new({classroom_activity_pairing_id: cap42.id ,student_user_id: 51, score_goal: 80, goal_date: "nil"})
		ag57 = ActivityGoal.new({classroom_activity_pairing_id: cap43.id ,student_user_id: 51, score_goal: 90, goal_date: "nil"})
		ag58 = ActivityGoal.new({classroom_activity_pairing_id: cap8.id ,student_user_id: 51, score_goal: 80, goal_date: "nil"})
		ag59 = ActivityGoal.new({classroom_activity_pairing_id: cap16.id ,student_user_id: 51, score_goal: 100, goal_date: "nil"})
		ag60 = ActivityGoal.new({classroom_activity_pairing_id: cap48.id ,student_user_id: 51, score_goal: 5, goal_date: "nil"})
		ag61 = ActivityGoal.new({classroom_activity_pairing_id: cap44.id ,student_user_id: 51, score_goal: 90, goal_date: "nil"})
		ag62 = ActivityGoal.new({classroom_activity_pairing_id: cap9.id ,student_user_id: 51, score_goal: 5, goal_date: "nil"})
		ag63 = ActivityGoal.new({classroom_activity_pairing_id: cap17.id ,student_user_id: 51, score_goal: 5, goal_date: "nil"})
		ag64 = ActivityGoal.new({classroom_activity_pairing_id: cap45.id ,student_user_id: 51, score_goal: 80, goal_date: "2015/10/28"})
		ag65 = ActivityGoal.new({classroom_activity_pairing_id: cap38.id ,student_user_id: 51, score_goal: 90, goal_date: "2015/10/28"})
		ag66 = ActivityGoal.new({classroom_activity_pairing_id: cap52.id ,student_user_id: 51, score_goal: 5, goal_date: "2015/10/30"})
		ag67 = ActivityGoal.new({classroom_activity_pairing_id: cap41.id ,student_user_id: 51, score_goal: 80, goal_date: "2015/11/02"})
		ag68 = ActivityGoal.new({classroom_activity_pairing_id: cap54.id ,student_user_id: 51, score_goal: 5, goal_date: "2015/11/05"})
		ag69 = ActivityGoal.new({classroom_activity_pairing_id: cap19.id ,student_user_id: 51, score_goal: 5, goal_date: "nil"})
		ag70 = ActivityGoal.new({classroom_activity_pairing_id: cap49.id ,student_user_id: 51, score_goal: 5, goal_date: "nil"})
		ag71 = ActivityGoal.new({classroom_activity_pairing_id: cap37.id ,student_user_id: 51, score_goal: 80, goal_date: "nil"})
		ag72 = ActivityGoal.new({classroom_activity_pairing_id: cap47.id ,student_user_id: 51, score_goal: 5, goal_date: "nil"})
		ag73 = ActivityGoal.new({classroom_activity_pairing_id: cap53.id ,student_user_id: 51, score_goal: 5, goal_date: "nil"})
		ag74 = ActivityGoal.new({classroom_activity_pairing_id: cap6.id ,student_user_id: 52, score_goal: 7, goal_date: "2015/11/01"})
		ag75 = ActivityGoal.new({classroom_activity_pairing_id: cap54.id ,student_user_id: 52, score_goal: 5, goal_date: "2015/11/02"})
		ag76 = ActivityGoal.new({classroom_activity_pairing_id: cap57.id ,student_user_id: 53, score_goal: 5, goal_date: "2015/11/02"})
		ag77 = ActivityGoal.new({classroom_activity_pairing_id: cap7.id ,student_user_id: 54, score_goal: 90, goal_date: "2015/10/28"})
		ag78 = ActivityGoal.new({classroom_activity_pairing_id: cap42.id ,student_user_id: 54, score_goal: 100, goal_date: "2015/10/29"})
		ag79 = ActivityGoal.new({classroom_activity_pairing_id: cap7.id ,student_user_id: 55, score_goal: 89, goal_date: "2015/10/28"})
		ag80 = ActivityGoal.new({classroom_activity_pairing_id: cap7.id ,student_user_id: 56, score_goal: 90, goal_date: "2015/10/29"})
		ag81 = ActivityGoal.new({classroom_activity_pairing_id: cap37.id ,student_user_id: 57, score_goal: 80, goal_date: "2015/10/27"})
		ag82 = ActivityGoal.new({classroom_activity_pairing_id: cap42.id ,student_user_id: 57, score_goal: 80, goal_date: "2015/10/27"})
		ag83 = ActivityGoal.new({classroom_activity_pairing_id: cap8.id ,student_user_id: 57, score_goal: 80, goal_date: "2015/10/28"})
		ag84 = ActivityGoal.new({classroom_activity_pairing_id: cap16.id ,student_user_id: 57, score_goal: 80, goal_date: "2015/10/28"})
		ag85 = ActivityGoal.new({classroom_activity_pairing_id: cap32.id ,student_user_id: 59, score_goal: 100, goal_date: "2015/10/28"})
		ag86 = ActivityGoal.new({classroom_activity_pairing_id: cap31.id ,student_user_id: 59, score_goal: 5, goal_date: "2015/10/28"})
		ag87 = ActivityGoal.new({classroom_activity_pairing_id: cap30.id ,student_user_id: 59, score_goal: 5, goal_date: "2015/10/28"})
		ag88 = ActivityGoal.new({classroom_activity_pairing_id: cap28.id ,student_user_id: 59, score_goal: 5, goal_date: "2015/10/28"})
		ag89 = ActivityGoal.new({classroom_activity_pairing_id: cap33.id ,student_user_id: 59, score_goal: 5, goal_date: "2015/11/02"})
		ag90 = ActivityGoal.new({classroom_activity_pairing_id: cap20.id ,student_user_id: 60, score_goal: 5, goal_date: "2015/11/03"})
		ag91 = ActivityGoal.new({classroom_activity_pairing_id: cap35.id ,student_user_id: 60, score_goal: 5, goal_date: "2015/11/03"})
		ag92 = ActivityGoal.new({classroom_activity_pairing_id: cap11.id ,student_user_id: 61, score_goal: 100, goal_date: "2015/10/27"})
		ag93 = ActivityGoal.new({classroom_activity_pairing_id: cap21.id ,student_user_id: 61, score_goal: 100, goal_date: "2015/10/27"})
		ag94 = ActivityGoal.new({classroom_activity_pairing_id: cap18.id ,student_user_id: 61, score_goal: 100, goal_date: "2015/10/29"})
		ag95 = ActivityGoal.new({classroom_activity_pairing_id: cap22.id ,student_user_id: 61, score_goal: 100, goal_date: "2015/11/02"})
		ag96 = ActivityGoal.new({classroom_activity_pairing_id: cap2.id ,student_user_id: 62, score_goal: 7, goal_date: "nil"})
		ag97 = ActivityGoal.new({classroom_activity_pairing_id: cap3.id ,student_user_id: 63, score_goal: 7, goal_date: "2015/11/04"})

		ag98 = ActivityGoal.new({classroom_activity_pairing_id: cap6.id ,student_user_id: self_student.id, score_goal: 6.5, goal_date: "2015/12/18"})
		ag99 = ActivityGoal.new({classroom_activity_pairing_id: cap7.id ,student_user_id: self_student.id, score_goal: 90, goal_date: "2015/11/13"})
		ag100 = ActivityGoal.new({classroom_activity_pairing_id: cap42.id ,student_user_id: self_student.id, score_goal: 80, goal_date: "2015/11/13"})
		ag101 = ActivityGoal.new({classroom_activity_pairing_id: cap8.id ,student_user_id: self_student.id, score_goal: 80, goal_date: "2015/11/13"})
		ag102 = ActivityGoal.new({classroom_activity_pairing_id: cap43.id ,student_user_id: self_student.id, score_goal: 80, goal_date: "2015/11/13"})
		ag103 = ActivityGoal.new({classroom_activity_pairing_id: cap16.id ,student_user_id: self_student.id, score_goal: 80, goal_date: "2015/11/20"})
		ag104 = ActivityGoal.new({classroom_activity_pairing_id: cap9.id ,student_user_id: self_student.id, score_goal: 5, goal_date: "2015/11/25"})
		
		ag1.save
		ag2.save
		ag3.save
		ag4.save
		ag5.save
		ag6.save
		ag7.save
		ag8.save
		ag9.save
		ag10.save
		ag11.save
		ag12.save
		ag13.save
		ag14.save
		ag15.save
		ag16.save
		ag17.save
		ag18.save
		ag19.save
		ag20.save
		ag21.save
		ag22.save
		ag23.save
		ag24.save
		ag25.save
		ag26.save
		ag27.save
		ag28.save
		ag29.save
		ag30.save
		ag31.save
		ag32.save
		ag33.save
		ag34.save
		ag35.save
		ag36.save
		ag37.save
		ag38.save
		ag39.save
		ag40.save
		ag41.save
		ag42.save
		ag43.save
		ag44.save
		ag45.save
		ag46.save
		ag47.save
		ag48.save
		ag49.save
		ag50.save
		ag51.save
		ag52.save
		ag53.save
		ag54.save
		ag55.save
		ag56.save
		ag57.save
		ag58.save
		ag59.save
		ag60.save
		ag61.save
		ag62.save
		ag63.save
		ag64.save
		ag65.save
		ag66.save
		ag67.save
		ag68.save
		ag69.save
		ag70.save
		ag71.save
		ag72.save
		ag73.save
		ag74.save
		ag75.save
		ag76.save
		ag77.save
		ag78.save
		ag79.save
		ag80.save
		ag81.save
		ag82.save
		ag83.save
		ag84.save
		ag85.save
		ag86.save
		ag87.save
		ag88.save
		ag89.save
		ag90.save
		ag91.save
		ag92.save
		ag93.save
		ag94.save
		ag95.save
		ag96.save
		ag97.save

		ag98.save
		ag99.save
		ag100.save
		ag101.save
		ag102.save
		ag103.save
		ag104.save

		puts "adding activity goal reflections..."
		ActivityGoalReflection.new({activity_goal_id: ag5.id , student_user_id:7, teacher_user_id: nil, reflection:"  I stay focus that is way i pass", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag6.id , student_user_id:7, teacher_user_id: nil, reflection:"  I will be fuocus    ", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag7.id , student_user_id:7, teacher_user_id: nil, reflection:"  Show my work", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag8.id , student_user_id:7, teacher_user_id: nil, reflection:"  I meet my goal", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag9.id , student_user_id:7, teacher_user_id: nil, reflection:"  Stay more focus", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag9.id , student_user_id:7, teacher_user_id: nil, reflection:"  I know table and stay focus and start to study", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag12.id , student_user_id:8, teacher_user_id: nil, reflection:"  I didnt meet my goal because i still wasnt sure if i knew how to multiply two digits by two digits right", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag14.id , student_user_id:9, teacher_user_id: nil, reflection:"  I didnt reach my goal because i didnt know almost all of the anwsers on the test and i will do better to make it to 80% on my goal.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag14.id , student_user_id:9, teacher_user_id: nil, reflection:"  Today i got 80% on multiplication 1-12 idid all of the anwsers correct.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag14.id , student_user_id:9, teacher_user_id: nil, reflection:"  I did the work right and did my best on the ones i didnt know even if i kinda knew the anwser", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag15.id , student_user_id:9, teacher_user_id: nil, reflection:"  I did all of the multiplication problems right even the ones i didnt know. I will practes my multiplication more to remember the ones i dont know. I will do a higher score and less time.", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag16.id , student_user_id:9, teacher_user_id: nil, reflection:"  I meet my goal by working hard and practesing. I will practec more and try my best. I will not use the answers that are on the end of the test.", reflection_date:" 2015/11/03"}).save
		ActivityGoalReflection.new({activity_goal_id: ag21.id , student_user_id:12, teacher_user_id: nil, reflection:"  I would use my notes to help me with this topic next time.Next time I would be a little bit more focused than I was today.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag25.id , student_user_id:16, teacher_user_id: nil, reflection:"  I met my goal by knowing how to do multiplication and i love multiplication.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag27.id , student_user_id:16, teacher_user_id: nil, reflection:"  I met goal by knowing how to do this i learn this in 4th grade so i kept practicing.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag28.id , student_user_id:16, teacher_user_id: nil, reflection:"  I met my goal by doing the problems amd taking my time ", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag29.id , student_user_id:16, teacher_user_id: nil, reflection:"  I met my goal by having a good attitude today and i had a good sleep😀. I would do the same thing.I would study with long divison and have a good attittude.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag30.id , student_user_id:16, teacher_user_id: nil, reflection:"  I met my goal by knowing how to do this and i was practicing.the thing i will do the same thing is by practicing. I would do differentely by doing a quiz by my own ", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag31.id , student_user_id:16, teacher_user_id: nil, reflection:"  I met my goal by doing my long division problems and knowing how to do this. I would do the same thing practicing ans quizing my self. I would do differently by like do this every day.", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag32.id , student_user_id:16, teacher_user_id: nil, reflection:"  I met my goal by by practicing knowing how to do this stuff.yes i would do the same thing and and practice more to not forget.i would do nothing", reflection_date:" 2015/11/03"}).save
		ActivityGoalReflection.new({activity_goal_id: ag35.id , student_user_id:17, teacher_user_id: nil, reflection:"  Next time i will do more work so I can under stand what to do.What I would do differently next time is to study more.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag36.id , student_user_id:17, teacher_user_id: nil, reflection:"  Next time I will take my time. Something I would do differently is to take my time again.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag37.id , student_user_id:17, teacher_user_id: nil, reflection:"  Next time i will take my time. Next time i will do differently is I would do my work ", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag38.id , student_user_id:17, teacher_user_id: nil, reflection:"  Next time I will take my time like last time. What I will do differently is doing work at the same time as im takeing my time.", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag47.id , student_user_id:19, teacher_user_id: nil, reflection:"  I am proud that I met my goal because I was focus on my work", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag48.id , student_user_id:19, teacher_user_id: nil, reflection:"  I am proud that I met my goal because I was focus.", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag48.id , student_user_id:19, teacher_user_id: nil, reflection:"  I met my goal because I was focus and on task.", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag51.id , student_user_id:19, teacher_user_id: nil, reflection:"  I met my goal because i wanted to good grade.I would stay focus the same.I will work on my timing.", reflection_date:" 2015/10/29"}).save
		ActivityGoalReflection.new({activity_goal_id: ag60.id , student_user_id:51, teacher_user_id: nil, reflection:"  I got a five because i practiced. I will stay focus as i did.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag61.id , student_user_id:51, teacher_user_id: nil, reflection:"  I passed my goal because i practiced on it", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag64.id , student_user_id:51, teacher_user_id: nil, reflection:"  I met my goal because i practiced on long division. I will stay ficus next time", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag65.id , student_user_id:51, teacher_user_id: nil, reflection:"  I met my goal because i knew all of the questions. I will focus as i did today. I will do the questions quicker.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag66.id , student_user_id:51, teacher_user_id: nil, reflection:"  I met my goal because i learned this from 5th grade. I will stay focus as i did today. I will work on timing next time.", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag68.id , student_user_id:51, teacher_user_id: nil, reflection:"  I met my goal because even though i was confused at first i still tried. i will stay focus as i did today. I will work on timing.", reflection_date:" 2015/11/02"}).save
		ActivityGoalReflection.new({activity_goal_id: ag75.id , student_user_id:52, teacher_user_id: nil, reflection:"  I will stay the same by practicing at home. I will be on task and by working my hard.", reflection_date:" 2015/11/02"}).save
		ActivityGoalReflection.new({activity_goal_id: ag76.id , student_user_id:53, teacher_user_id: nil, reflection:"  I met my goal by getting 5 out of 5and I got thisscore  because I stayed focused.I will do the same next time is Iwill stay focuse.I will do the different next time is that I wont make mistakes.", reflection_date:" 2015/11/02"}).save
		ActivityGoalReflection.new({activity_goal_id: ag77.id , student_user_id:54, teacher_user_id: nil, reflection:"  I meet my goal because i stuied my multiplication and i tried my best. Next time ill do the same but try to get 100%.", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag78.id , student_user_id:54, teacher_user_id: nil, reflection:"  I met my goal because i studied my multipilaction.", reflection_date:" 2015/10/29"}).save
		ActivityGoalReflection.new({activity_goal_id: ag80.id , student_user_id:56, teacher_user_id: nil, reflection:"  I did not met my goal that much because I expected to get a 90% or higher but i got a 80%.. Next time I will use my multiplication chart to study more.😀", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag81.id , student_user_id:57, teacher_user_id: nil, reflection:"  I meet my goal because I took my time on the questions. I will do the same next time. ", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag82.id , student_user_id:57, teacher_user_id: nil, reflection:"  I took my time in each problem and next time I will do the same.", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag83.id , student_user_id:57, teacher_user_id: nil, reflection:"  I meet my goal because i was taking my time. Next time i wil do the same thing. Next time i will get them all right. ", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag84.id , student_user_id:57, teacher_user_id: nil, reflection:"  I think i meet my goal because i took my time . Next tima i will do the same. Also, next time i will get less answers wrong ", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag91.id , student_user_id:60, teacher_user_id: nil, reflection:"  I met my goal because im smart and found out how to do this with mrs.h's help.😀👍🏻", reflection_date:" 2015/11/04"}).save
		ActivityGoalReflection.new({activity_goal_id: ag92.id , student_user_id:61, teacher_user_id: nil, reflection:"  I met my goal by doing my best and i tryed my hardest .i will do my best next time. ", reflection_date:" 2015/10/27"}).save
		ActivityGoalReflection.new({activity_goal_id: ag93.id , student_user_id:61, teacher_user_id: nil, reflection:"  I did meet my goal but it didnt let me track it.", reflection_date:" 2015/10/28"}).save
		ActivityGoalReflection.new({activity_goal_id: ag95.id , student_user_id:61, teacher_user_id: nil, reflection:"  I met my goal buy trying by best and focusing. I will keep focusing next time.", reflection_date:" 2015/11/03"}).save

		ActivityGoalReflection.new({activity_goal_id: ag99.id , student_user_id:self_student.id, teacher_user_id: nil, reflection:" I practiced for 20 min at home yesterday - yay!", reflection_date:" 2015/11/13"}).save
		ActivityGoalReflection.new({activity_goal_id: ag99.id , student_user_id:self_student.id, teacher_user_id: nil, reflection:" I'm not sure I know how to get better at this...  :(", reflection_date:" 2015/11/13"}).save
		ActivityGoalReflection.new({activity_goal_id: ag99.id , student_user_id:nil, teacher_user_id: teacher_user_id, reflection:" Excellent reflection - it seems like this strategy works well for you!", reflection_date:" 2015/11/13"}).save
		puts "----------------AFTER ADDITION----------------------------------"

		puts "Classroom count: #{Classroom.count}"
		puts "ClassroomStudentUser count: #{ClassroomStudentUser.count}"
		puts "Activity count: #{Activity.count}"
		puts "ActivityTagPairing count: #{ActivityTagPairing.count}"
		puts "ClassroomActivityPairing count: #{ClassroomActivityPairing.count}"
		puts "StudentPerformance count: #{StudentPerformance.count_all}"
		puts "StudentPerformanceVerification count: #{StudentPerformanceVerification.count}"
		puts "ActivityGoal count: #{ActivityGoal.count}"
		puts "ActivityGoalReflection count: #{ActivityGoalReflection.count}"


	end
end