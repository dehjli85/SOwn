//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.Scores", function(Scores, TeacherAccount, Backbone, Marionette, $, _){

	Scores.Controller = {

		startScoresApp: function(classroomLayoutView, readOrEdit){
			if(!readOrEdit == null)
				readOrEdit = "read";

			var classroomId = classroomLayoutView.model.attributes.classroomId

			var scoresLayoutView = Scores.Controller.showClassroomScoresLayout(classroomLayoutView, classroomId, readOrEdit);

			Scores.Controller.showClassroomScoresHeader(scoresLayoutView, classroomId);

			if (scoresLayoutView.model.attributes.readOrEdit == "read"){
				Scores.Controller.showClassroomScores(scoresLayoutView, classroomId, null, null);
			}
			else if(scoresLayoutView.model.attributes.readOrEdit == "edit"){
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
				scoresLayoutView.model.attributes.searchTerm = searchTerm;
				scoresLayoutView.model.attributes.tagIds = null;
				getURL +=  "&search_term=" + encodeURIComponent(searchTerm);
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

				if(data.status == "success"){

					// //create a new composite view for the table
					var classroomAndActivitiesModel = new Backbone.Model({activities:data.activities, classroom: data.classroom});
					classroomAndActivitiesModel.attributes.searchTerm = searchTerm;
					classroomAndActivitiesModel.attributes.tagIds = tagIds;

					var studentPerformancesCollection = new TeacherAccount.TeacherApp.Classroom.Scores.Models.StudentPerformanceCollection(data.students_with_performance);
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

				var tagCollectionView = new TeacherAccount.TeacherApp.Classroom.Scores.TagCollectionView({collection: tagCollection});	     	
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
				console.log('get request made');
			})
			.done(function(data) {

				if(data.status == "success"){
					
					var student_performance_verification = new Backbone.Model({activity:data.activity, student: data.student, student_performance: data.student_performance})
					var verifyModalView = new TeacherAccount.TeacherApp.Classroom.Scores.VerifyModalView({model: student_performance_verification});

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
			var jqxhr = $.post(postUrl, sortOrderPostData, function(){
				console.log('post request made');
			})
			.done(function(data) {
				
				if(data.status == "success"){

					Scores.Controller.showClassroomScores(scoresLayoutView, scoresLayoutView.model.attributes.classroomId, scoresLayoutView.model.attributes.searchTerm, scoresLayoutView.model.attributes.tagIds);
					
				}
				else if(data.status == "error"){
					console.log(data.errors);
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