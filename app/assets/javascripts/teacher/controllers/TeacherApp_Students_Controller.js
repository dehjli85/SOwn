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
				
				TeacherAccount.navigate("students/" + studentId + "/" + classroomId);

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