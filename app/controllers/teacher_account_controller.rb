class TeacherAccountController < ApplicationController

	before_action :require_teacher_login

	respond_to :json
	
	def home
		#TODO: check if the user is properly logged in 
		@classrooms = Classroom.where({teacher_user_id: session[:teacher_user_id]}).to_a
	end	

	def index
		
	end

	#return a json object representing the currently logged in teacher user
	def current_teacher_user

		current_user		

		render json: @current_teacher_user.to_json		
		
	end

	#return an array with json objects representing classrooms and the data needed for the teacher_home page
	def classrooms_summary

		current_user

		@classrooms = @current_teacher_user.classrooms

		a = Array.new
		@classrooms.each do |classroom|
			a.push({id: classroom.id, name: classroom.name, student_count: classroom.student_users.length, percent_proficient: (classroom.percent_proficient_activities*100).to_i})
		end

		render json: a.to_json
		
	end

	#return the json object representing a classroom with the specified id for the logged in user
	def classroom
		@classroom = Classroom.where({teacher_user_id: session[:teacher_user_id], id: params[:id]}).first

		render json: @classroom.to_json
	end

	#return the json object representing the unique tags for the classroom with the specified id for the logged in user
	def classroom_tags

		@classroom = Classroom.where({teacher_user_id: session[:teacher_user_id], id: params[:id]}).first

		render json: @classroom.tags.to_json
		
	end

	#return a json object with 2 attributes:
	# => activities: list of activities for the classrooms
	# => student_performances: array of student performances for activities in the classroom 
	# the activities and performances will be sorted the same
	def classroom_activities_and_performances
		
		@classroom = Classroom.where({teacher_user_id: session[:teacher_user_id], id: params[:id]}).first
		
		@search_matched_pairings_and_activities = @classroom.search_matched_pairings_and_activities({search_term: params[:search_term], tag_id: params[:tag_id]})

		performance_array = @search_matched_pairings_and_activities[:student_performances].to_a
		performance_array.each do |sp|

			sp["performance_pretty"] = StudentPerformance.performance_pretty_no_active_record(sp["activity_type"], sp["scored_performance"], sp["completed_performance"])			
			sp["performance_color"] = StudentPerformance.performance_color_no_active_record(sp["activity_type"], sp["benchmark1_score"], sp["benchmark2_score"], sp["min_score"], sp["max_score"], sp["scored_performance"], sp["completed_performance"])
			
		end

		@students = @classroom.student_users		
		
		render json: {students: @students, activities: @search_matched_pairings_and_activities[:activities], student_performances: performance_array}

	end

end
