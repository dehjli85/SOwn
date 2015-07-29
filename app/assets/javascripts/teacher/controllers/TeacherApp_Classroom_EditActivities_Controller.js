//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.EditActivities", function(EditActivities, TeacherAccount, Backbone, Marionette, $, _){

	EditActivities.Controller = {

		showClassroomEditActivities: function(layoutView, classroomId, activityId){			

			//Create the Layout View
			var editActivitiesLayoutView = new TeacherAccount.TeacherApp.Classroom.EditActivities.LayoutView({model: new Backbone.Model({classroomId: classroomId})});
			layoutView.mainRegion.show(editActivitiesLayoutView);

			// render the activity assignment view
			EditActivities.Controller.renderActivityAssignmentView(editActivitiesLayoutView,classroomId,activityId);
			
			
		},

		showClassroomEditActivitiesVerificationsView: function(editActivitiesLayoutView, classroomId, activityId){

			var jqxhr2 = $.get("/teacher/teacher_activities_verifications?id=" + classroomId + "&activity_id=" + activityId, function(){
				console.log('get request for verifications data');
			})
			.done(function(data) {				

				var verifications = new TeacherAccount.TeacherApp.Classroom.EditActivities.Models.VerificationsCollection(data);
														
				var verificationsCompositeView = new TeacherAccount.TeacherApp.Classroom.EditActivities.VerificationsCompositeView({collection:verifications, model: new Backbone.Model({classroomId:classroomId})});
				editActivitiesLayoutView.verificationsRegion.show(verificationsCompositeView);

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		renderActivityAssignmentView: function(editActivitiesLayoutView, classroomId, activityId){

			//create activity assignment view and add it to the layout
			var getUrl = "/teacher/teacher_activities_and_classroom_assignment?id=" + classroomId;
			if(activityId != null)
				getUrl += "&activity_id=" + activityId
			var jqxhr = $.get(getUrl, function(){
				console.log('get request for classroom activities made');
			})
			.done(function(data) {

				var activities = new TeacherAccount.TeacherApp.Classroom.EditActivities.Models.ActivitiesCollection(data.activities);
				var activity = new TeacherAccount.TeacherApp.Classroom.EditActivities.Models.Activity({pairing: data.pairing, activity: data.activity});

				var activitiyAssignmentView = new TeacherAccount.TeacherApp.Classroom.EditActivities.ActivityAssignmentView({model: activity, collection: activities});
				editActivitiesLayoutView.activityAssignmentRegion.show(activitiyAssignmentView);

				if(activity.attributes.pairing != null){
					EditActivities.Controller.showClassroomEditActivitiesVerificationsView(editActivitiesLayoutView, classroomId, data.activity.id);
				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		saveActivityAssignmentAndVerifications: function(editActivitiesLayoutView, classroomId, activityId, activityAssigned, verificationsForm){
			console.log(classroomId);
			var postUrl = "/teacher/save_teacher_activity_assignment_and_verifications"
			var postParams = "classroom_id=" + classroomId + "&activity_id=" + activityId + "&assigned=" + activityAssigned;
			if (verificationsForm != null)
				postParams +=  "&" + verificationsForm.serialize()

			var jqxhr = $.post(postUrl, postParams, function(){
				console.log('get request for classroom activities made');
			})
			.done(function(data) {

				if(data.activity == 'no-change' || data.activity == 'success-assign' || data.activity == 'success-unassign'){
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