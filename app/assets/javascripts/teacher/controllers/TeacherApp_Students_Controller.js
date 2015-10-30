//= require teacher/teacher

TeacherAccount.module("TeacherApp.Students", function(Students, TeacherAccount, Backbone, Marionette, $, _){

	Students.Controller = {
	

		showIndexCompositeView: function(searchTerm){

			// create activity assignment view and add it to the layout
			var getUrl = "/teacher/students?";			
			if(searchTerm != null){
				getUrl += "searchTerm=" + encodeURIComponent(searchTerm);
			}
			
			var jqxhr = $.get(getUrl, function(){
				console.log('get request list of students');
			})
			.done(function(data) {

				var model = new Backbone.Model({searchTerm: searchTerm});
				var studentsCollection = new Backbone.Collection(data.students);

				var indexCompositeView = new TeacherAccount.TeacherApp.Students.IndexCompositeView({collection: studentsCollection, model:model});

				var studentsLayoutView = new TeacherAccount.TeacherApp.Students.StudentsLayoutView({model:model});
				TeacherAccount.rootView.mainRegion.show(studentsLayoutView);

				studentsLayoutView.mainRegion.show(indexCompositeView);
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		showStudentView: function(studentsLayoutView, studentId, classroomId){

			var getUrl = "/teacher/student_activities_and_performances?" 
			+ "student_user_id=" + encodeURIComponent(studentId)
			+ "&classroom_id=" + encodeURIComponent(classroomId);

			var jqxhr = $.get(getUrl, function(){
				console.log('get request for data for student view info');
			})
			.done(function(data) {

				console.log(data);
				
				TeacherAccount.navigate("students/show/" + studentId + "/" + classroomId);

				var collection = new Backbone.Collection(data.activities);
				var model = new Backbone.Model({student: data.student, classroom:data.classroom})

				studentsLayoutView.model.attributes.student = data.student;

				var showStudentCompositeView = new TeacherAccount.TeacherApp.Students.ShowStudentCompositeView({collection: collection, model: model});
				studentsLayoutView.mainRegion.show(showStudentCompositeView);

				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		openSeeAllModal: function(studentsLayoutView, classroomActivityPairingId, studentId){

			var getURL = "/teacher/activity_and_performances?" 
				+ "classroom_activity_pairing_id=" + classroomActivityPairingId
				+ "&student_user_id=" + studentId;
			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){

	     		var activity_pairing_performances = new Backbone.Model({activity: data.activity, classroom_activity_pairing: data.classroom_activity_pairing, performances:data.performances, errors:{}});
	     		var seeAllModal = new StudentAccount.StudentApp.Classroom.SeeAllModalView({model: activity_pairing_performances});
	     		studentsLayoutView.modalRegion.show(seeAllModal);

	     		if (data.activity.activity_type == 'scored'){

		     		var modelData = [];
		     		var index = 1;

		     		var dates = [];
		     		var counter = 1;
						data.performances.map(function(item){

		     			//set color of bars
							var color = "#49883F";
							if(item.performance_color == "danger-sown")
								color = "#B14F51";
							else if(item.performance_color == 'warning-sown')
								color = "#EACD46";

							//set data depending on activity type
							var next = moment(item.performance_date).format("MM/DD");
							if($.inArray(moment(item.performance_date).format("MM/DD"), dates) >=  0){
								counter++;
								next += " (" + counter + ")";
							}
							else{
								counter = 1;
							}
							dates.push(moment(item.performance_date).format("MM/DD"));

							modelData.push({x: next, y: item.performance_pretty, color: color})
							index++;

						});	 

						var modelLabels = {x: "Attempt", y: "Score"};

						var scoreRangeObj = {min_score: data.activity.min_score, benchmark1_score: data.activity.benchmark1_score, benchmark2_score: data.activity.benchmark2_score, max_score: data.activity.max_score};

						var model = new Backbone.Model({data:modelData, labels: modelLabels, score_range: scoreRangeObj});

						var barGraphView = new StudentAccount.StudentApp.Classroom.PerformanceBarGraphView({model: model});

						seeAllModal.graphRegion.show(barGraphView);

					}
					else if (data.activity.activity_type == 'completion'){
						
						var model = new Backbone.Model({performances: data.performances});
						var completionTableView = new StudentAccount.StudentApp.Classroom.CompletionTableView({model: model});

						seeAllModal.graphRegion.show(completionTableView);

					}

					
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		openActivityDetailsModal: function(studentsLayoutView, classroomActivityPairingId, studentId){

			var getURL = "/teacher/student_activity?" 
				+ "classroom_activity_pairing_id=" + classroomActivityPairingId
				+ "&student_user_id=" + studentId;
			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){

	     		var activityModel = new Backbone.Model(data.activity);
	     		var activityDetailsModalView = new StudentAccount.StudentApp.Classroom.ActivityDetailsModalView({model: activityModel});
	     		studentsLayoutView.modalRegion.show(activityDetailsModalView);

					
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		openRemoveStudentModal: function(studentsLayoutView, studentId, classroomId){
			var getURL = "/teacher/classroom_student_user?" 
				+ "classroom_id=" + classroomId
				+ "&student_user_id=" + studentId;
			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){

	     		var classroomStudentUserModel = new Backbone.Model(data.classroom_student_user);
	     		var removeStudentConfirmationModalView = new TeacherAccount.TeacherApp.Students.RemoveStudentConfirmationModalView({model: classroomStudentUserModel});
	     		studentsLayoutView.modalRegion.show(removeStudentConfirmationModalView);

					
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			
		},

		removeStudent: function(classroomStudentUserId, studentUserId, classroomId){
			var postURL = "/teacher/classroom_remove_student" 

			var postData = "classroom_id=" + classroomId
				+ "&student_user_id=" + studentUserId
				+ "&classroom_student_user_id=" + classroomStudentUserId;
			var jqxhr = $.post(postURL, postData, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {

     		$('.modal-backdrop').remove(); //This is a hack, don't know why the backdrop isn't going away
     		$('body').removeClass('modal-open'); //This is a hack, don't know why the backdrop isn't going away

				Students.Controller.showIndexCompositeView();

	     	if(data.status == "success"){

					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Student successfully removed!"});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model:alertModel});

					TeacherAccount.rootView.alertRegion.show(alertView);

					
	     	}else{

					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-danger", message: "Sorry, there was an error removing the student."});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model:alertModel});

					TeacherAccount.rootView.alertRegion.show(alertView);

	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	

		}


	}

})