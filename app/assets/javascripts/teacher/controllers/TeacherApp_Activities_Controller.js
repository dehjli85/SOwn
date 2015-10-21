//= require teacher/teacher

TeacherAccount.module("TeacherApp.Activities", function(Activities, TeacherAccount, Backbone, Marionette, $, _){

	Activities.Controller = {
		
		showActivitiesIndex: function(){			

			//Create the Index Layout View
			var model = new Backbone.Model({tags: []});
			var indexLayoutView = new TeacherAccount.TeacherApp.Activities.IndexLayoutView({model: model});
			TeacherAccount.rootView.mainRegion.show(indexLayoutView);
			
			Activities.Controller.showIndexSearchBarView(indexLayoutView);

			Activities.Controller.showIndexTagCollectionView(indexLayoutView);

			Activities.Controller.showIndexActivitiesCompositeView(indexLayoutView);

			
		},

		showIndexSearchBarView: function(indexLayoutView){

			var searchBarView = new TeacherAccount.TeacherApp.Activities.IndexSearchBarView();
			indexLayoutView.searchBarRegion.show(searchBarView);
		},

		showIndexTagCollectionView: function(indexLayoutView){
			var jqxhr = $.get("/teacher/activities_tags", function(){
				console.log('get request made');
			})
			.done(function(data) {
				
				var tagCollection = new Backbone.Collection(data.tags);

				var tagCollectionView = new TeacherAccount.TeacherApp.TagCollectionView({collection: tagCollection});	     	
				indexLayoutView.tagsRegion.show(tagCollectionView);
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		showIndexActivitiesCompositeView: function(indexLayoutView, searchTerm, tagIds ){

			// create activity assignment view and add it to the layout
			var getUrl = "/teacher/teacher_activities_and_tags?";
			if(tagIds != null){
				getUrl += "tag_ids=" + encodeURIComponent(JSON.stringify(tagIds));
			}
			if(searchTerm != null){
				getUrl += "search_term=" + searchTerm;
			}
			
			var jqxhr = $.get(getUrl, function(){
				console.log('get request for teacher activities and tags made');
			})
			.done(function(data) {

				console.log(data);

				var activitiesCollection = new TeacherAccount.TeacherApp.Activities.Models.IndexActivitiesCollection(data.activities);

				var indexCompositeView = new TeacherAccount.TeacherApp.Activities.IndexCompositeView({collection: activitiesCollection});
				console.log(indexCompositeView);
				indexLayoutView.mainRegion.show(indexCompositeView);
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		openEditActivityDialog: function(indexLayoutView, activityId){

			// var getUrl = "/classrooms_summary";
			var getUrl = "/teacher/activity?activity_id=" + activityId;

			var jqxhr = $.get(getUrl, function(){
				console.log('get request made');
			})
			.done(function(data) {

				if(data.status == "success"){

					var model = new Backbone.Model(data.activity);
					model.set("errors", {});
					model.set("tagCount", 0);
					model.set("classroomId", null);

					var teacher_tags = [];
					data.activity_tags.map(function(i){teacher_tags.push(i.name)});
					model.set("teacher_tags", teacher_tags);
					
					var collection = new Backbone.Collection();

					// This is a new Activity
					if(activityId == null){
						model.set("activity_status", "New");
						model.set("activity_type", "scored");
					}
					// This is an existing activity
					else{
						model.set("activity_status", "Edit");
						collection = new Backbone.Collection(data.activity.tags);
					}

					var editActivityModalCompositeView = new TeacherAccount.TeacherApp.Activities.EditActivityModalCompositeView({model: model, collection: collection});
					
					indexLayoutView.modalRegion.show(editActivityModalCompositeView);
					indexLayoutView.ui.modalRegion.modal("show");
						
				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		
		},

		saveNewActivity: function(indexLayoutView, editActivityModalCompositeView){
			var postUrl = "/teacher/save_new_activity";
			var jqxhr = $.post(postUrl, editActivityModalCompositeView.ui.activityForm.serialize(), function(){
				console.log('post request to save new activity');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					// assign to classes
					var postUrl = "/teacher/assign_activities"
					var jqxhr = $.post(postUrl, editActivityModalCompositeView.ui.activityForm.serialize() + "&activity_id=" + data.activity.id, function(){
						console.log('post request to assign activities');
					})
					.done(function(data2) {

						console.log(data2);
						if(data.status == "success"){

							var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Assignments successfully saved!"});
							var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
							
							TeacherAccount.rootView.alertRegion.show(alertView);

							Activities.Controller.showIndexActivitiesCompositeView(indexLayoutView);

							indexLayoutView.ui.modalRegion.modal("hide");
							indexLayoutView.modalRegion.empty();

						}
						else{
							//show an error message
						}

						
						
						
				  })
				  .fail(function() {
				  	console.log("error");
				  })
				  .always(function() {
				   
					});	


					
				}
				else{
					//show an error message
					editActivityModalCompositeView.showErrors(data.errors);

				}

				
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	
		},


		updateActivity: function(indexLayoutView, editActivityModalCompositeView){
			var postUrl = "/teacher/update_activity/" + editActivityModalCompositeView.model.get("id");
			var jqxhr = $.post(postUrl, editActivityModalCompositeView.ui.activityForm.serialize(), function(){
				console.log('post request to save new activity');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					// assign to classes
					var postUrl = "/teacher/assign_activities"
					var jqxhr = $.post(postUrl, editActivityModalCompositeView.ui.activityForm.serialize() + "&activity_id=" + data.activity.id, function(){
						console.log('post request to assign activities');
					})
					.done(function(data2) {

						console.log(data2);
						if(data.status == "success"){

							var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Assignments successfully saved!"});
							var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
							
							TeacherAccount.rootView.alertRegion.show(alertView);

							Activities.Controller.showIndexActivitiesCompositeView(indexLayoutView);

							indexLayoutView.ui.modalRegion.modal("hide");
							indexLayoutView.modalRegion.empty();

						}
						else{
							//show an error message
						}
						
				  })
				  .fail(function() {
				  	console.log("error");
				  })
				  .always(function() {
				   
					});	
					
				}
				else{
					//show an error message
					editActivityModalCompositeView.showErrors(data.errors);

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

		openDeleteActivityModal: function(indexLayoutView, activityId){

			// create activity assignment view and add it to the layout
			var getUrl = "/teacher/student_performance_count?activity_id=" + activityId;			
			
			var jqxhr = $.get(getUrl, function(){
				console.log('get request for teacher activity');
			})
			.done(function(data) {

				if(data.status == "success"){

					var model = new Backbone.Model({student_performance_count: data.student_performance_count, student_count: data.student_count, activity: data.activity});

					var deleteActivityModal = new TeacherAccount.TeacherApp.Activities.DeleteActivityModalView({model: model});
					indexLayoutView.modalRegion.show(deleteActivityModal);
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
		},

		deleteActivity: function(indexLayoutView, activityForm){
			
			TeacherAccount.rootView.alertRegion.empty();

			var postUrl = "/teacher/delete_activity"
			var jqxhr = $.post(postUrl, activityForm.serialize(), function(){
				console.log('post request to assign activities');
			})
			.done(function(data) {

				console.log(data);
				if(data.status == "success"){

					indexLayoutView.ui.modalRegion.modal("hide");
					indexLayoutView.modalRegion.empty();
					$('.modal-backdrop').remove(); //This is a hack, don't know why the backdrop isn't going away
					$('body').removeClass('modal-open'); //This is a hack, don't know why the backdrop isn't going away
					
					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Activity successfully deleted!"});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
					
					TeacherAccount.rootView.alertRegion.show(alertView);
					Activities.Controller.showActivitiesIndex();
				}
				else{
					//show an error message
					
				}


				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	

		},

		

	}

})