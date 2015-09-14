//= require student/student

StudentAccount.module("StudentApp.Classroom", function(Classroom, StudentAccount, Backbone, Marionette, $, _){

	Classroom.Controller = {

		// startClassroomApp: function(classroomId, subapp){
			
		// 	var classroomLayoutView = Classroom.Controller.showClassroomLayout(classroomId);

		// 	StudentAccount.StudentApp.Classroom.Controller.showClassroomHeader(classroomLayout,classroomId, subapp);


		// },

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

			//show search bar
			// Classroom.Controller.showClassroomSearchBarView(classroomLayoutView, searchTerm);
   		
   		// Classroom.Controller.showClassroomTagCollectionView(classroomLayoutView, classroomId);

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

	     		console.log(data);

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

	     		var activity_pairing_performances = new Backbone.Model({activity: data.activity, classroom_activity_pairing: data.classroom_activity_pairing, performances:data.performances, errors:{}});
	     		var seeAllModal = new StudentAccount.StudentApp.Classroom.SeeAllModalView({model: activity_pairing_performances});
	     		classroomLayoutView.modalRegion.show(seeAllModal);

					
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
	     		var activityDetailsModalView = new StudentAccount.StudentApp.Classroom.ActivityDetailsModalView({model: activityModel});
	     		classroomLayoutView.modalRegion.show(activityDetailsModalView);

					
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