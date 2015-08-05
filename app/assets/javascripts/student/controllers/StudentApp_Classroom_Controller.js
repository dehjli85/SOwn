//= require student/student

StudentAccount.module("StudentApp.Classroom", function(Classroom, StudentAccount, Backbone, Marionette, $, _){

	Classroom.Controller = {

		showClassroomLayout: function(classroomId){
			console.log(classroomId);
			var classroom = new Backbone.Model({classroomId: classroomId})
			var layoutView = new StudentAccount.StudentApp.Classroom.LayoutView({model: classroom});			
			StudentAccount.rootView.mainRegion.show(layoutView);

			return layoutView;
		},

		showClassroomHeader: function(classroomLayoutView, classroomId, subapp){

			var jqxhr = $.get("/student/classroom?classroom_id=" + classroomId, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {

	     	if(data.status == "success"){
	     		
					var classroom = new StudentAccount.StudentApp.Classroom.Models.Classroom(data.classroom);
					
		     	var headerView = new StudentAccount.StudentApp.Classroom.HeaderView({model:classroom});			
					classroomLayoutView.headerRegion.show(headerView);	
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		showClassroomScores: function(classroomLayoutView, classroomId){			

			var jqxhr = $.get("/student/classroom_activities_and_performances?classroom_id=" + classroomId, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){
	     		
					var activities = new StudentAccount.StudentApp.Classroom.Models.ActivityCollection(data.activities);
					var activityCompositeView = new StudentAccount.StudentApp.Classroom.ActivitiesCompositeView({collection:activities});

					classroomLayoutView.mainRegion.show(activityCompositeView);
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		openTrackModal: function(classroomLayoutView, classroomActivityPairingId, studentId){

			var getURL = "/student/activity?classroom_activity_pairing_id=" + classroomActivityPairingId;
			getURL += "&student_user_id=" + studentId
			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){


	     		
	     		var activity_and_pairing = new Backbone.Model({activity: data.activity, classroom_activity_pairing: data.classroom_activity_pairing, errors:{}});
	     		var trackModal = new StudentAccount.StudentApp.Classroom.TrackModalView({model: activity_and_pairing});
	     		classroomLayoutView.modalRegion.show(trackModal);

					
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		savePerformance: function(classroomLayoutView, trackModalView, performanceForm){

			var postUrl = "/student/save_student_performance";
			var jqxhr = $.post(postUrl, performanceForm.serialize(), function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){
	     		
	     		classroomLayoutView.ui.modalRegion.modal("hide");
	     		classroomLayoutView.modalRegion.empty();

	     		Classroom.Controller.showClassroomScores(classroomLayoutView, classroomLayoutView.model.get("classroomId"));
	     		

	     	}
	     	else if(data.status == "error"){
	     		trackModalView.model.attributes.errors = data.student_performance_errors
	     		trackModalView.render();

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