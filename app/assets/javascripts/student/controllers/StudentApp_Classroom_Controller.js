//= require student/student

StudentAccount.module("StudentApp.Classroom", function(Classroom, StudentAccount, Backbone, Marionette, $, _){

	Classroom.Controller = {

		showClassroomLayout: function(classroomId){
			var classroom = new Backbone.Model({classroomId: classroomId, tags: []})
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

			Classroom.Controller.showClassroomSearchBarView(classroomLayoutView, null);

			Classroom.Controller.showClassroomTagCollectionView(classroomLayoutView, classroomId);
			
		},

		showClassroomSearchBarView: function(classroomLayoutView, searchTerm){
			var searchBarModel = new Backbone.Model({searchTerm: searchTerm})
   		var searchBarView = new StudentAccount.StudentApp.Classroom.SearchBarView({model: searchBarModel});
   		classroomLayoutView.searchRegion.show(searchBarView);

		},

		showClassroomTagCollectionView: function(classroomLayoutView, classroomId){
			//show the tags for the classroom activities
   		var jqxhr = $.get("/student/classroom_tags?classroom_id=" + classroomId, function(){
				console.log('get request made');
			})
			.done(function(data) {
				
				var tagCollection = new Backbone.Collection(data);

				var tagCollectionView = new StudentAccount.StudentApp.Classroom.TagCollectionView({collection: tagCollection});	     	
				classroomLayoutView.tagsRegion.show(tagCollectionView);
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		showClassroomScores: function(classroomLayoutView, classroomId, searchTerm, tagIds){			
			
   		//show scores view
   		var getURL = "/student/classroom_activities_and_performances?classroom_id=" + classroomId 
			if(searchTerm){
				classroomLayoutView.model.attributes.searchTerm = searchTerm;
				classroomLayoutView.model.attributes.tagId = null;
				getURL +=  "&search_term=" + encodeURIComponent(searchTerm)
			}
			if(tagIds){
				classroomLayoutView.model.attributes.searchTerm = null;
				classroomLayoutView.model.attributes.tagIds = tagIds;
				getURL +=  "&tag_ids=" + encodeURIComponent(JSON.stringify(tagIds));

			}

			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){

					var activities = new StudentAccount.StudentApp.Classroom.Models.ActivityCollection(data.activities);
					var activityCompositeView = new StudentAccount.StudentApp.Classroom.ActivitiesCompositeView({collection:activities});

					classroomLayoutView.scoresRegion.show(activityCompositeView);
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		openTrackModal: function(classroomLayoutView, classroomActivityPairingId){

			var getURL = "/student/activity?classroom_activity_pairing_id=" + classroomActivityPairingId;
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

	     		Classroom.Controller.showClassroomScores(classroomLayoutView, classroomLayoutView.model.get("classroomId"), classroomLayoutView.model.get("searchTerm"), classroomLayoutView.model.get("tags"));

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

		},

		openSeeAllModal: function(classroomLayoutView, classroomActivityPairingId){

			var getURL = "/student/activity_and_performances?classroom_activity_pairing_id=" + classroomActivityPairingId;
			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){

	     		var activity_pairing_performances = new Backbone.Model({activity: data.activity});
	     		var seeAllModal = new StudentAccount.StudentApp.Classroom.SeeAllModalView({model: activity_pairing_performances});
	     		classroomLayoutView.modalRegion.show(seeAllModal);

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

						var barGraphView = new StudentAccount.StudentApp.Classroom.SetGoalBarGraphView({model: model});

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

		openSetGoalModal: function(classroomLayoutView, classroomActivityPairingId){

			var getURL = "/student/activity_and_performances?classroom_activity_pairing_id=" + classroomActivityPairingId;
			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {

     		console.log(data);

	     	if(data.status == "success"){

	     		var model = new Backbone.Model({activity: data.activity, classroom_activity_pairing: data.classroom_activity_pairing, activity_goal: data.activity_goal});
	     		var setGoalModalView = new StudentAccount.StudentApp.Classroom.SetGoalModalView({model: model});
	     		classroomLayoutView.modalRegion.show(setGoalModalView);


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

							var barGraphView = new StudentAccount.StudentApp.Classroom.SetGoalBarGraphView({model: model});

							setGoalModalView.graphRegion.show(barGraphView);
						}
						else if (data.activity.activity_type == 'completion'){
							

							if(data.performances.length != 0){
								var model = new Backbone.Model({performances: data.performances});
									
								var completionTableView = new StudentAccount.StudentApp.Classroom.CompletionTableView({model: model});

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

		openActivityDetailsModal: function(classroomLayoutView, classroomActivityPairingId){

			var getURL = "/student/activity?classroom_activity_pairing_id=" + classroomActivityPairingId;
			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){

	     		var activityModel = new Backbone.Model(data.activity);
	     		activityModel.set("classroom_activity_pairing", data.classroom_activity_pairing);
	     		var activityDetailsModalView = new StudentAccount.StudentApp.Classroom.ActivityDetailsModalView({model: activityModel});
	     		classroomLayoutView.modalRegion.show(activityDetailsModalView);

					
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		saveNewActivityGoal: function(classroomLayoutView, goalForm){

			var alertModel = new Backbone.Model({message: "Saving Activity Goal...", alertClass: "alert-warning"})
			var alertView = new StudentAccount.StudentApp.AlertView({model: alertModel});
			StudentAccount.rootView.alertRegion.show(alertView);

			var postURL = "/student/save_new_activity_goal";
			var postData = goalForm.serialize();
			var jqxhr = $.post(postURL, postData, function(){
				console.log('post request for saving new activity goal');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){
					classroomLayoutView.ui.modalRegion.modal("hide");

					var alertModel = new Backbone.Model({message: "Activity Goal Saved!", alertClass: "alert-success"});
					var alertView = new StudentAccount.StudentApp.AlertView({model: alertModel});
					StudentAccount.rootView.alertRegion.show(alertView);					

					Classroom.Controller.showClassroomScores(classroomLayoutView, classroomLayoutView.model.get("classroomId"), null, null);					
	     	}else{
					
					var alertModel = new Backbone.Model({message: "Error Saving Activity Goal!", alertClass: "alert-danger"});
					var alertView = new StudentAccount.StudentApp.AlertView({model: alertModel});
					StudentAccount.rootView.alertRegion.show(alertView);						     		
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