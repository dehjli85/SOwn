//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.Scores", function(Scores, TeacherAccount, Backbone, Marionette, $, _){

	Scores.Controller = {

		startScoresApp: function(classroomLayoutView, readOrEdit){
			if(!readOrEdit == null)
				readOrEdit = "read";

			var classroomId = classroomLayoutView.model.attributes.classroomId

			var scoresLayoutView = Scores.Controller.showClassroomScoresLayout(classroomLayoutView, classroomId, readOrEdit);

			Scores.Controller.showClassroomScoresHeader(scoresLayoutView, classroomId);

			if (scoresLayoutView.model.get("readOrEdit") == "read"){
				Scores.Controller.showClassroomScores(scoresLayoutView, classroomId, null, null);
			}
			else if(scoresLayoutView.model.get("readOrEdit") == "edit"){
				Scores.Controller.showClassroomEditScores(scoresLayoutView, classroomId, null, null);
			}

		},

		showClassroomScoresLayout: function(classroomLayoutView, classroomId, readOrEdit){

			var model = new Backbone.Model({classroomId: classroomId, readOrEdit: readOrEdit, tags:[]});
			var scoresLayoutView = new TeacherAccount.TeacherApp.Classroom.Scores.LayoutView({model:model});
			classroomLayoutView.mainRegion.show(scoresLayoutView);

			return scoresLayoutView;
		},

		showClassroomScores: function(scoresLayoutView, classroomId, searchTerm, tagIds){			

			var getURL = "/teacher/classroom_activities_and_performances?classroom_id=" + classroomId 
			if(searchTerm){
				scoresLayoutView.model.set("searchTerm", searchTerm);
				scoresLayoutView.model.set("tagIds", null);
				getURL +=  "&search_term=" + encodeURIComponent(searchTerm);
			}
			if(tagIds){
				scoresLayoutView.model.set("searchTerm", null);
				scoresLayoutView.model.set("tagIds", tagIds);
				getURL +=  "&tag_ids=" + encodeURIComponent(JSON.stringify(tagIds));
			}

			var jqxhr = $.get(getURL, function(){
				console.log('get request made for classroom scores data: ' + scoresLayoutView.model.get("classroomId"));
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					// //create a new composite view for the table
					var classroomAndActivitiesModel = new Backbone.Model({activities:data.activities, classroom: data.classroom});
					classroomAndActivitiesModel.set("searchTerm", searchTerm);
					classroomAndActivitiesModel.set("tagIds", tagIds);

					var studentPerformancesCollection = new Backbone.Collection(data.students_with_performance);
					console.log(studentPerformancesCollection);
					var scoresView = new TeacherAccount.TeacherApp.Classroom.Scores.ScoresView({collection: studentPerformancesCollection, model:classroomAndActivitiesModel});
					scoresLayoutView.scoresRegion.show(scoresView);

				}
				else{
					console.log(data);
				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		showClassroomEditScores: function(scoresLayoutView, classroomId, searchTerm, tagIds){
			
			var getURL = "/teacher/classroom_activities_and_performances?classroom_id=" + classroomId 
			
			if(searchTerm){
				scoresLayoutView.model.attributes.searchTerm = searchTerm;
				scoresLayoutView.model.attributes.tagIds = null;
				getURL +=  "&search_term=" + encodeURIComponent(searchTerm)
			}
			if(tagIds){
				scoresLayoutView.model.attributes.searchTerm = null;
				scoresLayoutView.model.attributes.tagIds = tagIds;
				getURL +=  "&tag_ids=" + encodeURIComponent(JSON.stringify(tagIds));
			}

			var jqxhr = $.get(getURL, function(){
				console.log('get request made: ' + scoresLayoutView.model.attributes.classroomId);
			})
			.done(function(data) {

				console.log(data);

				// //create a new composite view for the table
				var classroomAndActivitiesModel = new TeacherAccount.TeacherApp.Classroom.Scores.Models.Activities({activities:data.activities, classroom: data.classroom});
				classroomAndActivitiesModel.attributes.searchTerm = searchTerm;
				classroomAndActivitiesModel.attributes.tagIds = tagIds;
				
				var studentPerformancesCollection = new TeacherAccount.TeacherApp.Classroom.Scores.Models.StudentPerformanceCollection(data.students_with_performance);

				var editScoresView = new TeacherAccount.TeacherApp.Classroom.Scores.EditScoresView({collection: studentPerformancesCollection, model:classroomAndActivitiesModel});
				scoresLayoutView.scoresRegion.show(editScoresView);
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		saveClassroomScores: function(scoresLayoutView, studentPerformanceForm){

			var postUrl = "/teacher/save_student_performances"

			var jqxhr = $.post(postUrl, studentPerformanceForm.serialize(), function(){
				console.log('get request made');
			})
			.done(function(data) {
				
				if(data.status == "success"){
					
					TeacherAccount.navigate("classroom/scores/" + scoresLayoutView.model.get("classroomId"));
					Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.get("classroomId"), scoresLayoutView.model.attributes.searchTerm, scoresLayoutView.model.attributes.tagId);

				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		showClassroomSearchBarView: function(scoresLayoutView){
			var searchBar = new TeacherAccount.TeacherApp.Classroom.Scores.SearchBarView();
			scoresLayoutView.searchBarRegion.show(searchBar);
		},

		showClassroomTagCollectionView: function(scoresLayoutView, classroomId){

			var jqxhr = $.get("/teacher/classroom_tags?classroom_id=" + classroomId, function(){
				console.log('get request made');
			})
			.done(function(data) {
				
				var tagCollection = new TeacherAccount.TeacherApp.Classroom.Scores.Models.TagCollection(data);

				var tagCollectionView = new TeacherAccount.TeacherApp.TagCollectionView({collection: tagCollection});	     	
				scoresLayoutView.tagsRegion.show(tagCollectionView);
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		showClassroomScoresHeader: function(scoresLayoutView, classroomId){

			//create the search bar view and add it to the layout
			Scores.Controller.showClassroomSearchBarView(scoresLayoutView);

			//create the tags view and add it to the layout
			Scores.Controller.showClassroomTagCollectionView(scoresLayoutView, classroomId);

		},

		showVerifyModal: function(scoresLayoutView, studentPerformanceId){

			var getUrl = "/teacher/student_performance?student_performance_id=" + studentPerformanceId;
			var jqxhr = $.get(getUrl, function(){
				console.log('get request made to get verify modal data');
			})
			.done(function(data) {

				console.log(data.student_performance.performance_date);

				if(data.status == "success"){
					
					var student_performance_verification = new Backbone.Model({activity:data.activity, student: data.student, student_performance: data.student_performance})
					var verifyModalView = new TeacherAccount.TeacherApp.Classroom.Scores.VerifyModalView({model: student_performance_verification});
					console.log(verifyModalView.model.get("student_performance").performance_date);
					scoresLayoutView.modalRegion.show(verifyModalView);
					scoresLayoutView.ui.modalRegion.modal("show");
						
				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		saveVerify: function(scoresLayoutView, verifyForm){

			var postUrl = "/teacher/save_verify";
			var jqxhr = $.post(postUrl, verifyForm.serialize(), function(){
				console.log('post request made');
			})
			.done(function(data) {
				
				if(data.status == "success"){

					//close the modal
					scoresLayoutView.ui.modalRegion.modal("hide");

					//re-render the scores 
					Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.get("classroomId"), scoresLayoutView.model.attributes.searchTerm, scoresLayoutView.model.attributes.tagId);

				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		saveActivitiesSortOrder: function(scoresLayoutView, scoresView, sortOrderPostData){

			var postUrl = "/teacher/save_activities_sort_order";
			console.log(scoresView);
			var jqxhr = $.post(postUrl, sortOrderPostData, function(){
				console.log('post request made');
			})
			.done(function(data) {

				if(data.status == "success"){

					Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.attributes.classroomId, scoresLayoutView.model.attributes.searchTerm, scoresLayoutView.model.attributes.tagIds);
					
				}
				else if(data.status == "error"){
					console.log(data);
				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		

		openEditActivityDialog: function(scoresLayoutView, activityId){


			// var getUrl = "/classrooms_summary";
			var getUrl = "/teacher/activity?activity_id=" + activityId;

			var jqxhr = $.get(getUrl, function(){
				console.log('get request made');
			})
			.done(function(data) {
				console.log(data);

				if(data.status == "success"){

					var layoutModel = new Backbone.Model(data.activity);
					layoutModel.set("errors", {});
					layoutModel.set("classroomId", scoresLayoutView.model.get("classroomId"));
					
					var teacher_tags = [];
					data.activity_tags.map(function(i){teacher_tags.push(i.name)});
					layoutModel.set("teacher_tags", teacher_tags);
					
					var activityTagsCollection = new Backbone.Collection();
					var activityLevelsCollection = new Backbone.Collection();

					// This is a new Activity
					if(activityId == null){
						layoutModel.set("activity_status", "New");
						layoutModel.set("activity_type", "scored");
						layoutModel.set("activity_tags", activityTagsCollection);
						layoutModel.set("tagCount", 0);
						layoutModel.set("activity_levels", activityLevelsCollection);
						layoutModel.set("levelCount", 0);

						// make a get request to get all the teacher's activities to use for the typeahead for copying activities
						getUrl = "/teacher/teacher_activities_and_tags";
						var jqxhr2 = $.get(getUrl, function(){
							console.log('get request made');
						})
						.done(function(data) {
							console.log(data);


							if(data.status == "success"){
								layoutModel.set("activities", data.activities);

								var activity_names = [];
								data.activities.map(function(i){activity_names.push(i.name)});
								layoutModel.set("activity_names", activity_names);

							}
							
							var editActivityModalLayoutView = new TeacherAccount.TeacherApp.Activities.EditActivityModalLayoutView({model: layoutModel});

							scoresLayoutView.modalRegion.show(editActivityModalLayoutView);
							scoresLayoutView.ui.modalRegion.modal("show");
							
					  })
					  .fail(function() {
					  	console.log("error");
					  })
					  .always(function() {
					   
						});	

					}
					// This is an existing activity
					else{
						layoutModel.set("activity_status", "Edit");
						activityTagsCollection = new Backbone.Collection(data.activity.tags);
						activityLevelsCollection = new Backbone.Collection(data.activity.levels);
						layoutModel.set("activity_tags", activityTagsCollection);
						layoutModel.set("tagCount", activityTagsCollection.length);
						layoutModel.set("activity_levels", activityLevelsCollection);
						layoutModel.set("levelCount", activityLevelsCollection.length);

						var editActivityModalLayoutView = new TeacherAccount.TeacherApp.Activities.EditActivityModalLayoutView({model: layoutModel});
						
						scoresLayoutView.modalRegion.show(editActivityModalLayoutView);
						scoresLayoutView.ui.modalRegion.modal("show");
					}

						
				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	


		},

		openAssignActivitiesDialog: function(scoresLayoutView){

			var getUrl = "/teacher/teacher_activities_and_tags?classroom_id=" + scoresLayoutView.model.get("classroomId");
			var jqxhr = $.get(getUrl, function(){
				console.log('get request made');
			})
			.done(function(data) {

				if(data.status == "success"){

					console.log(data);

					var collection = new Backbone.Collection(data.activities);

					var classroomAssignActivitiesModalCompositeView = new TeacherAccount.TeacherApp.Activities.ClassroomAssignActivitiesModalCompositeView({collection: collection});
					
					scoresLayoutView.modalRegion.show(classroomAssignActivitiesModalCompositeView);
					scoresLayoutView.ui.modalRegion.modal("show");
						
				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	

		},

		saveNewActivity: function(scoresLayoutView, editActivityModalLayoutView){
			var postUrl = "/teacher/save_new_activity";
			var jqxhr = $.post(postUrl, editActivityModalLayoutView.ui.activityForm.serialize(), function(){
				console.log('post request to save new activity');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					// assign to classes
					var postUrl = "/teacher/assign_activities"
					var jqxhr = $.post(postUrl, editActivityModalLayoutView.ui.activityForm.serialize() + "&activity_id=" + data.activity.id, function(){
						console.log('post request to assign activities');
					})
					.done(function(data2) {

						console.log(data2);
						if(data.status == "success"){

							var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Assignments successfully saved!"});
							var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
							
							TeacherAccount.rootView.alertRegion.show(alertView);

							Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.get("classroomId"), null, []);

							scoresLayoutView.ui.modalRegion.modal("hide");
							scoresLayoutView.modalRegion.empty();

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
					editActivityModalLayoutView.showErrors(data.errors);

				}

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	
		},

		updateActivity: function(scoresLayoutView, editActivityModalLayoutView){
			var postUrl = "/teacher/update_activity/" + editActivityModalLayoutView.model.get("id");
			var jqxhr = $.post(postUrl, editActivityModalLayoutView.ui.activityForm.serialize(), function(){
				console.log('post request to save new activity');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					// assign to classes
					var postUrl = "/teacher/assign_activities"
					var jqxhr = $.post(postUrl, editActivityModalLayoutView.ui.activityForm.serialize() + "&activity_id=" + data.activity.id, function(){
						console.log('post request to assign activities');
					})
					.done(function(data2) {

						console.log(data2);
						if(data.status == "success"){

							var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Assignments successfully saved!"});
							var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
							
							TeacherAccount.rootView.alertRegion.show(alertView);

							Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.get("classroomId"), null, []);

							scoresLayoutView.ui.modalRegion.modal("hide");
							scoresLayoutView.modalRegion.empty();

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
					editActivityModalLayoutView.model.set("errors", data.errors);
					editActivityModalLayoutView.model.set("level_errors", data.level_errors);
					editActivityModalLayoutView.model.set("tag_errors", data.tag_errors);
					editActivityModalLayoutView.model.set("tag_pairing_errors", data.tag_pairing_errors);
					editActivityModalLayoutView.showErrors();

				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	
		},

		saveClassroomActivityAssignments: function(scoresLayoutView, assignmentForm){

			// post request to save data
			var postUrl = "/teacher/save_activity_assignments";
			var postData = assignmentForm.serialize() + "&classroom_id=" + scoresLayoutView.model.get("classroomId");
			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request to save activity assignments for classroom ' + scoresLayoutView.model.get("classroomId"));
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Activities Assigned!"});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
					
					TeacherAccount.rootView.alertRegion.show(alertView);

					Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.get("classroomId"), null, []);

					scoresLayoutView.ui.modalRegion.modal("hide");
					scoresLayoutView.modalRegion.empty();

				}
				
				else{

					//show an error message
					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-danger", message: "Error assigning activities..."});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
					
					TeacherAccount.rootView.alertRegion.show(alertView);

				}

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	

		},

		showGoalModal: function(classroomLayoutView, classroomScoresLayoutView, studentPerformanceView){

			console.log(studentPerformanceView.model.attributes);
			// get request to get data for the modal
			var getURL = "/teacher/activity_and_performances?classroom_activity_pairing_id=" + studentPerformanceView.model.get("classroomActivityPairingId") + "&student_user_id=" + studentPerformanceView.model.get("id");
			var jqxhr = $.get(getURL, function(){
				console.log('get request for data for goal modal');
			})
			.done(function(data) {

     		console.log(data);

	     	if(data.status == "success"){

	     		var model = studentPerformanceView.model.clone();
	     		model.set("activity", data.activity);
	     		model.set("classroom_activity_pairing", data.classroom_activity_pairing);
	     		model.set("activity_goal", data.activity_goal);

	     		var setGoalModalView = new TeacherAccount.TeacherApp.Classroom.Scores.SetGoalModalView({model: model});

	     		classroomLayoutView.modalRegion.show(setGoalModalView);
	     		classroomLayoutView.ui.modalRegion.modal("show");

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

							// var model = new Backbone.Model({data:modelData, labels: modelLabels, score_range: scoreRangeObj});
		     			var model = studentPerformanceView.model.clone();
		     			model.set("data", modelData);
		     			model.set("labels",  modelLabels);
		     			model.set("score_range", scoreRangeObj);

							var barGraphView = new TeacherAccount.TeacherApp.Classroom.Scores.PerformanceBarGraphView({model: model});

							setGoalModalView.graphRegion.show(barGraphView);
						}
						else if (data.activity.activity_type == 'completion'){
							

							if(data.performances.length != 0){
								var model = new Backbone.Model({performances: data.performances});
									
								var completionTableView = new TeacherAccount.TeacherApp.Classroom.ScoresCompletionTableView({model: model});

								setGoalModalView.graphRegion.show(completionTableView);
							}

						}	
					
	     	}
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		showTrackModal: function(scoresLayoutView, classroomActivityPairingId, studentUserId){
			
			var getURL = "/teacher/activity_and_performances?classroom_activity_pairing_id=" + classroomActivityPairingId + "&student_user_id=" + studentUserId;
			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
				console.log(data);
	     	if(data.status == "success"){
	     		
	     		var model = new Backbone.Model({activity: data.activity, 
	     			classroom_activity_pairing: data.classroom_activity_pairing, 
	     			performances: data.performances, 
	     			errors:{},
	     			student_user_id: studentUserId
	     		});
	     		var trackModal = new StudentAccount.StudentApp.Classroom.TrackModalView({model: model});
	     		scoresLayoutView.modalRegion.show(trackModal);
	     		scoresLayoutView.ui.modalRegion.modal("show");
					
	     	}
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		saveReflection: function(classroomLayoutView, scoresLayoutView, setGoalModalView){

			var alertModel = new Backbone.Model({message: "Saving Activity Goal...", alertClass: "alert-warning"})
			var alertView = new StudentAccount.StudentApp.AlertView({model: alertModel});
			TeacherAccount.rootView.alertRegion.show(alertView);

			var postURL = "/teacher/save_reflection";
			var postData = setGoalModalView.ui.goalForm.serialize();
			var jqxhr = $.post(postURL, postData, function(){
				console.log('post request for saving new activity goal');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){
					classroomLayoutView.ui.modalRegion.modal("hide");

					var alertModel = new Backbone.Model({message: "Activity Goal Saved!", alertClass: "alert-success"});
					var alertView = new StudentAccount.StudentApp.AlertView({model: alertModel});
					TeacherAccount.rootView.alertRegion.show(alertView);					

					Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.get("classroomId"), scoresLayoutView.model.get("searchTerm"), scoresLayoutView.model.get("tagId"));

	     	}else{
					
					var alertModel = new Backbone.Model({message: "Error Saving Activity Goal!", alertClass: "alert-danger"});
					var alertView = new StudentAccount.StudentApp.AlertView({model: alertModel});
					TeacherAccount.rootView.alertRegion.show(alertView);						     		
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});		

		},

		savePerformance: function(scoresLayoutView, trackModalView, performanceTableCompositeView){

			var postUrl = "/teacher/save_student_performance";
			var postData = performanceTableCompositeView.ui.performanceTableForm.serialize();
			postData += "&student_user_id=" + trackModalView.model.get("student_user_id");

			var jqxhr = $.post(postUrl, postData, function(){
				console.log('get request to save new performances');
			})
			.done(function(data) {
				console.log(data);
	     	if(data.status == "success"){
	     		
	     		Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.get("classroomId"), scoresLayoutView.model.get("searchTerm"), scoresLayoutView.model.get("tagIds"));
	     		Scores.Controller.showTrackModal(scoresLayoutView, performanceTableCompositeView.model.get("classroom_activity_pairing").id, trackModalView.model.get("student_user_id"));

	     	}
	     	else if(data.status == "error"){
	     		performanceTableCompositeView.model.set("student_performance_errors", data.student_performance_errors);
	     		performanceTableCompositeView.render();

	     	}
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		saveAllPerformances: function(scoresLayoutView, trackModalView, performanceTableCompositeView){

			var postUrl = "/teacher/save_all_student_performances";
			var postData = performanceTableCompositeView.ui.performanceTableForm.serialize();
			postData += "&student_user_id=" + trackModalView.model.get("student_user_id");
			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request to save all performances');
			})
			.done(function(data) {
     		console.log(data);

	     	if(data.status == "success"){
	     		Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.get("classroomId"), scoresLayoutView.model.get("searchTerm"), scoresLayoutView.model.get("tagIds"));
	     		Scores.Controller.showTrackModal(scoresLayoutView, performanceTableCompositeView.model.get("classroom_activity_pairing").id, trackModalView.model.get("student_user_id"));

	     	}
	     	else if(data.status == "error"){
	     		performanceTableCompositeView.model.set("errors", data.errors);
	     		performanceTableCompositeView.render();

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