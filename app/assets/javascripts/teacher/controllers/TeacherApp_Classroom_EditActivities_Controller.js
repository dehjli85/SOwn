//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.EditActivities", function(EditActivities, TeacherAccount, Backbone, Marionette, $, _){

	EditActivities.Controller = {

		showClassroomEditActivities: function(layoutView, classroomId, activityId){			

			var getUrl = "/teacher/teacher_activities_and_tags?";			
			
			var jqxhr = $.get(getUrl, function(){
				console.log('get request for teacher activities and tags made');
			})
			.done(function(data) {

				if(data.status == "success"){

					//Create the Layout View
					var editActivitiesLayoutView = new TeacherAccount.TeacherApp.Classroom.EditActivities.LayoutView({model: new Backbone.Model({classroomId: classroomId, activities:data.activities})});
					layoutView.mainRegion.show(editActivitiesLayoutView);

					// render the activity assignment view
					if(data.activities.length > 0){
						EditActivities.Controller.renderActivityAssignmentView(editActivitiesLayoutView,classroomId,activityId);
					}
				}		
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});		

			
			
		},

		showClassroomEditActivitiesAssignmentOptionsView: function(editActivitiesLayoutView, classroomId, activityId, pairing){

			var jqxhr2 = $.get("/teacher/teacher_activities_verifications?classroom_id=" + classroomId + "&activity_id=" + activityId, function(){
				console.log('get request for verifications data');
			})
			.done(function(data) {				

				var verifications = new TeacherAccount.TeacherApp.Classroom.EditActivities.Models.VerificationsCollection(data.verifications);
														
				var assignmentOptionsCompositeView = new TeacherAccount.TeacherApp.Classroom.EditActivities.AssignmentOptionsCompositeView({collection:verifications, model: new Backbone.Model({classroomId:classroomId, pairing:pairing})});
				editActivitiesLayoutView.optionsRegion.show(assignmentOptionsCompositeView);

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		renderActivityAssignmentView: function(editActivitiesLayoutView, classroomId, activityId){

			//create activity assignment view and add it to the layout
			var getUrl = "/teacher/teacher_activities_and_classroom_assignment?classroom_id=" + classroomId;
			if(activityId != null)
				getUrl += "&activity_id=" + activityId
			var jqxhr = $.get(getUrl, function(){
				console.log('get request for classroom activities made');
			})
			.done(function(data) {

				console.log(data);

				var activities = new TeacherAccount.TeacherApp.Classroom.EditActivities.Models.ActivitiesCollection(data.activities);
				var activity = new TeacherAccount.TeacherApp.Classroom.EditActivities.Models.Activity({pairing: data.pairing, activity: data.activity});

				var activitiyAssignmentView = new TeacherAccount.TeacherApp.Classroom.EditActivities.ActivityAssignmentView({model: activity, collection: activities});
				editActivitiesLayoutView.activityAssignmentRegion.show(activitiyAssignmentView);

				if(activity.attributes.pairing != null){
					EditActivities.Controller.showClassroomEditActivitiesAssignmentOptionsView(editActivitiesLayoutView, classroomId, data.activity.id, activity.attributes.pairing);
				}else{
					editActivitiesLayoutView.optionsRegion.empty();
				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		saveActivityAssignmentAndOptions: function(editActivitiesLayoutView, classroomId, activityId, activityAssigned, activityHidden, verificationsForm){
			var postUrl = "/teacher/save_teacher_activity_assignment_and_verifications"
			var postParams = "classroom_id=" + classroomId 
				+ "&activity_id=" + activityId 
				+ "&assigned=" + activityAssigned
				+ "&hidden=" + activityHidden;
			if (verificationsForm != null)
				postParams +=  "&" + verificationsForm.serialize();


			var jqxhr = $.post(postUrl, postParams, function(){
				console.log('get request for classroom activities made');
			})
			.done(function(data) {


				if(data.assignment_status == 'no-change' || data.assignment_status == 'success-assign' || data.assignment_status == 'success-unassign'){
					var alertModel = new TeacherAccount.TeacherApp.Classroom.EditActivities.Models.Alert({message: "Successfully Saved!", alertClass: "alert-success"});
					var alertView = new TeacherAccount.TeacherApp.Classroom.EditActivities.AlertView({model: alertModel});
					editActivitiesLayoutView.alertRegion.show(alertView);
				}else{

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