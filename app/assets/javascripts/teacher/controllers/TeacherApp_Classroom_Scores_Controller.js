//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.Scores", function(Scores, TeacherAccount, Backbone, Marionette, $, _){

	Scores.Controller = {

		showClassroomScores: function(layoutView, classroomId){			

			//Create the Layout View
			var scoresLayoutView = new TeacherAccount.TeacherApp.Classroom.Scores.LayoutView({model: new Backbone.Model({classroomId: classroomId})});
			layoutView.mainRegion.show(scoresLayoutView);

			console.log(classroomId);

			//create the search bar view and add it to the layout
			var searchBar = new TeacherAccount.TeacherApp.Classroom.Scores.SearchBarView();
			scoresLayoutView.searchBarRegion.show(searchBar);

			//create the tags view and add it to the layout
			var jqxhr = $.get("/teacher/classroom_tags?id=" + classroomId, function(){
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
			


			var jqxhr = $.get("/teacher/classroom_activities_and_performances?id=" + classroomId, function(){
				console.log('get request made: ' + classroomId);
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

				var scoresView = new TeacherAccount.TeacherApp.Classroom.Scores.ScoresView({collection: studentPerformancesCollection, model:activitiesModel});
				scoresLayoutView.scoresRegion.show(scoresView);

				
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		}
	}

})