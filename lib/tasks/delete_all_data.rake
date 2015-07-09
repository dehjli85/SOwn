namespace :app do
  desc <<-DESC
    Load testing data.
    Run using the command 'rake app:load_demo_data'
  DESC
  task :delete_all_data => [:environment] do
		StudentUser.delete_all
		TeacherUser.delete_all
		Activity.delete_all
		Classroom.delete_all
		ActivityTag.delete_all
		ActivityTagPairing.delete_all
		StudentPerformance.delete_all
		StudentPerformanceVerification.delete_all
		ClassroomActivityPairing.delete_all
	end
end
