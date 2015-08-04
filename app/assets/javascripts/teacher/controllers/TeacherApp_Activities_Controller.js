//= require teacher/teacher

TeacherAccount.module("TeacherApp.Activities", function(Activities, TeacherAccount, Backbone, Marionette, $, _){

	Activities.Controller = {
		
		showActivitiesIndex: function(){			

			//Create the Index Layout View
			var indexLayoutView = new TeacherAccount.TeacherApp.Activities.IndexLayoutView();
			TeacherAccount.rootView.mainRegion.show(indexLayoutView);
			
			Activities.Controller.showIndexHeaderView(indexLayoutView);

			Activities.Controller.showIndexActivitiesCompositeView(indexLayoutView);

			
		},

		showIndexHeaderView: function(indexLayoutView){

			var headerView = new TeacherAccount.TeacherApp.Activities.IndexHeaderView();
			indexLayoutView.headerRegion.show(headerView);
		},

		showIndexActivitiesCompositeView: function(indexLayoutView, tagId, searchTerm){

			// create activity assignment view and add it to the layout
			var getUrl = "/teacher/teacher_activities_and_tags?";
			if(tagId != null){
				getUrl += "tagId=" + tagId;
			}
			if(searchTerm != null){
				getUrl += "searchTerm=" + searchTerm;
			}
			
			var jqxhr = $.get(getUrl, function(){
				console.log('get request for teacher activities and tags made');
			})
			.done(function(data) {

				var activitiesCollection = new TeacherAccount.TeacherApp.Activities.Models.IndexActivitiesCollection(data.activities);

				var indexCompositeView = new TeacherAccount.TeacherApp.Activities.IndexCompositeView({collection: activitiesCollection});
				indexLayoutView.mainRegion.show(indexCompositeView);
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},


		showNewActivity: function(){

			var activity = new TeacherAccount.TeacherApp.Activities.Models.Activity({
				name: "",
				description: "",
				instructions: "",
				activity_type: "completion",
				activity_status: "New",
				max_score: "",
				benchmark1_score: "",
				benchmark2_score: "",
				min_score: "",
				tagCount: 0, 
				errors: {}
			});

			
			var collection = new TeacherAccount.TeacherApp.Activities.Models.TagCollection([]);
			var editActivityCompositeView = new TeacherAccount.TeacherApp.Activities.EditActivityCompositeView({model:activity, collection: collection});
			TeacherAccount.rootView.mainRegion.show(editActivityCompositeView);

		},

		showEditActivity: function(id){

			// create activity assignment view and add it to the layout
			var getUrl = "/teacher/activity?activity_id=" + id;			
			
			var jqxhr = $.get(getUrl, function(){
				console.log('get request for teacher activity');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					var activity = new TeacherAccount.TeacherApp.Activities.Models.Activity(data.activity);
					activity.attributes.tagCount = data.activity.tags.length;
					activity.attributes.errors = {};
					activity.attributes.activity_status = "Edit";

					var collection = new TeacherAccount.TeacherApp.Activities.Models.TagCollection(data.activity.tags);
					var editActivityCompositeView = new TeacherAccount.TeacherApp.Activities.EditActivityCompositeView({model:activity, collection: collection});
					console.log(collection);
					console.log(editActivityCompositeView);
					TeacherAccount.rootView.mainRegion.show(editActivityCompositeView);	
				}

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			
			
			
		},

		saveNewActivity: function(editActivityCompositeView){

			var postUrl = "/teacher/save_new_activity";
			var jqxhr = $.post(postUrl, editActivityCompositeView.ui.activityForm.serialize(), function(){
				console.log('post request to save new activity');
			})
			.done(function(data) {

				console.log(data);
				if(data.status == "success"){
					//show a success message, render the edit activity page
					// console.log("success")
					Activities.Controller.showActivitiesIndex();

					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Activity successfully saved!"});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
					TeacherAccount.navigate("activities/index")
					TeacherAccount.rootView.alertRegion.show(alertView);
					
				}
				else{
					//show an error message
					editActivityCompositeView.showErrors(data.errors);
				}

				
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	
		},

		updateActivity: function(editActivityCompositeView){

			var postUrl = "/teacher/update_activity/" + editActivityCompositeView.model.get("id")
			var jqxhr = $.post(postUrl, editActivityCompositeView.ui.activityForm.serialize(), function(){
				console.log('post request to update activity');
			})
			.done(function(data) {

				console.log(data);
				if(data.status == "success"){
					
					Activities.Controller.showActivitiesIndex();

					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Activity successfully saved!"});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
					TeacherAccount.navigate("activities/index")
					TeacherAccount.rootView.alertRegion.show(alertView);
				}
				else{
					//show an error message
					editActivityCompositeView.showErrors(data.errors);
				}

				
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	
		},


		openAssignActivitiesModal: function(indexLayoutView, activityId){

			// create activity assignment view and add it to the layout
			var getUrl = "/teacher/classroom_assignments?activity_id=" + activityId;			
			
			var jqxhr = $.get(getUrl, function(){
				console.log('get request for teacher activity');
			})
			.done(function(data) {

				if(data.status == "success"){

					var classroomAssignment = new TeacherAccount.TeacherApp.Activities.Models.ClassroomAssignment({classrooms: data.classrooms, activity:data.activity});

					var assignActivitiesModal = new TeacherAccount.TeacherApp.Activities.AssignActivitiesModalView({model: classroomAssignment});
					indexLayoutView.modalRegion.show(assignActivitiesModal);
				}	

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		saveActivityAssignments: function(indexLayoutView, assignmentForm){
			
			TeacherAccount.rootView.alertRegion.empty();

			var postUrl = "/teacher/assign_activities"
			var jqxhr = $.post(postUrl, assignmentForm.serialize(), function(){
				console.log('post request to assign activities');
			})
			.done(function(data) {

				console.log(data);
				if(data.status == "success"){

					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Assignments successfully saved!"});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
					
					TeacherAccount.rootView.alertRegion.show(alertView);
				}
				else{
					//show an error message
					
				}

				indexLayoutView.ui.modalRegion.modal("hide");
				indexLayoutView.modalRegion.empty();
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	
		}
		

	}

})