//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.Scores", function(Scores, TeacherAccount, Backbone, Marionette, $, _){

	Scores.Controller = {

		showClassroomScores: function(layoutView, classroomId, searchTerm, tagId){			

			var scoresLayoutView = Scores.Controller.showClassroomScoresHeader(layoutView,classroomId, 'read');

			var getURL = "/teacher/classroom_activities_and_performances?classroom_id=" + classroomId 
			if(searchTerm){
				getURL +=  "&search_term=" + encodeURIComponent(searchTerm)
			}
			if(tagId){
				getURL +=  "&tag_id=" + tagId
			}

			console.log(getURL);

			var jqxhr = $.get(getURL, function(){
				console.log('get request made: ' + scoresLayoutView.model.attributes.classroomId);
			})
			.done(function(data) {

				var activity_indices = {};				
				for(var i=0; i < data.activities.length; i++){					
					activity_indices[data.activities[i].id] = i;
				}

				var students = [];								
				var student_indices = {};
				for(var i=0; i < data.students.length; i++){												
					student_indices[data.students[i].id] = i;
					students[i] = {student: data.students[i], student_performance: []};
				}

				for(var i=0; i < data.student_performances.length; i++){	
					var activities_index = activity_indices[data.student_performances[i].activity_id];					
					var student_index = student_indices[data.student_performances[i].student_user_id];					
					
					if(!students[student_index].student_performance[activities_index] || ((new Date(students[student_index].student_performance[activities_index].performance_date.replace(/T|Z/g, " "))) < (new Date(data.student_performances[i].performance_date.replace(/T|Z/g, " ")))))
						students[student_index].student_performance[activities_index] = data.student_performances[i];
				}

				// //create a new composite view for the table
				var activitiesModel = new TeacherAccount.TeacherApp.Classroom.Scores.Models.Activities({activities:data.activities});
				var studentPerformancesCollection = new TeacherAccount.TeacherApp.Classroom.Scores.Models.StudentPerformanceCollection(students);

				console.log(studentPerformancesCollection);

				var scoresView = new TeacherAccount.TeacherApp.Classroom.Scores.ScoresView({collection: studentPerformancesCollection, model:activitiesModel});
				scoresLayoutView.scoresRegion.show(scoresView);

				
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		showClassroomEditScores: function(layoutView, classroomId, searchTerm, tagId){

			var scoresLayoutView = Scores.Controller.showClassroomScoresHeader(layoutView,classroomId, "edit");
			
			var getURL = "/teacher/classroom_activities_and_performances?classroom_id=" + classroomId 
			if(searchTerm){
				getURL +=  "&search_term=" + encodeURIComponent(searchTerm)
			}
			if(tagId){
				getURL +=  "&tag_id=" + tagId
			}
			var jqxhr = $.get(getURL, function(){
				console.log('get request made: ' + scoresLayoutView.model.attributes.classroomId);
			})
			.done(function(data) {

				var activity_indices = {};				
				for(var i=0; i < data.activities.length; i++){					
					activity_indices[data.activities[i].id] = i;
				}

				var students = [];								
				var student_indices = {};
				for(var i=0; i < data.students.length; i++){												
					student_indices[data.students[i].id] = i;
					students[i] = {student: data.students[i], student_performance: []};
				}

				for(var i=0; i < data.student_performances.length; i++){	
					var activities_index = activity_indices[data.student_performances[i].activity_id];					
					var student_index = student_indices[data.student_performances[i].student_user_id];					
					
					if(!students[student_index].student_performance[activities_index] || ((new Date(students[student_index].student_performance[activities_index].performance_date.replace(/T|Z/g, " "))) < (new Date(data.student_performances[i].performance_date.replace(/T|Z/g, " ")))))
						students[student_index].student_performance[activities_index] = data.student_performances[i];
				}

				// //create a new composite view for the table
				var activitiesModel = new TeacherAccount.TeacherApp.Classroom.Scores.Models.Activities({activities:data.activities, classroomId: classroomId});
				var studentPerformancesCollection = new TeacherAccount.TeacherApp.Classroom.Scores.Models.StudentPerformanceCollection(students);

				

				var editScoresView = new TeacherAccount.TeacherApp.Classroom.Scores.EditScoresView({collection: studentPerformancesCollection, model:activitiesModel});
				scoresLayoutView.scoresRegion.show(editScoresView);

				
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		saveClassroomScores: function(studentPerformanceForm){

			var postUrl = "/teacher/save_student_performances"

			var jqxhr = $.post(postUrl, studentPerformanceForm.serialize(), function(){
				console.log('get request made');
			})
			.done(function(data) {
				
				console.log(data);
				
				if(data.status == "success"){

					Scores.Controller.showClassroomScores(TeacherAccount.rootView.mainRegion.currentView, data.classroomId);	

				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		showClassroomScoresHeader: function(layoutView, classroomId, readOrEdit){

			//Create the Layout View
			var scoresLayoutView = new TeacherAccount.TeacherApp.Classroom.Scores.LayoutView({model: new Backbone.Model({classroomId: classroomId, readOrEdit: readOrEdit})});
			layoutView.mainRegion.show(scoresLayoutView);

			console.log(classroomId);

			//create the search bar view and add it to the layout
			var searchBar = new TeacherAccount.TeacherApp.Classroom.Scores.SearchBarView();
			scoresLayoutView.searchBarRegion.show(searchBar);

			//create the tags view and add it to the layout
			var jqxhr = $.get("/teacher/classroom_tags?classroom_id=" + classroomId, function(){
				console.log('get request made');
			})
			.done(function(data) {
				
				var tagCollection = new TeacherAccount.TeacherApp.Classroom.Scores.Models.TagCollection(data);

				console.log("tag Collection:");
				console.log(tagCollection);
				var tags = new TeacherAccount.TeacherApp.Classroom.Scores.TagCollectionView({collection: tagCollection});	     	
				scoresLayoutView.tagsRegion.show(tags);
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

			return scoresLayoutView;

		}
	}

})