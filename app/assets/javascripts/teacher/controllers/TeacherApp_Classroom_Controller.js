//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom", function(Classroom, TeacherAccount, Backbone, Marionette, $, _){

	Classroom.Controller = {

		showClassroomLayout: function(classroomId){


			var classroomLayoutView = new TeacherAccount.TeacherApp.Classroom.LayoutView();			
			classroomLayoutView.model = new Backbone.Model({classroomId:classroomId})

			TeacherAccount.rootView.mainRegion.show(classroomLayoutView);

			return classroomLayoutView;
		},

		showClassroomHeader: function(classroomLayoutView, classroomId, subapp){

			var jqxhr = $.get("/teacher/classroom?classroom_id=" + classroomId, function(){
				console.log('get request for classroom model');
			})
			.done(function(classroomAPIModelData) {
	     	
	     	classroomAPIModelData.subapp = subapp;

				var classroomModel = new TeacherAccount.TeacherApp.Classroom.Models.Classroom(classroomAPIModelData);
				console.log(classroomModel);
				
	     	var headerView = new TeacherAccount.TeacherApp.Classroom.HeaderView({model:classroomModel});			
				classroomLayoutView.headerRegion.show(headerView);
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		startScoresApp: function(classroomLayoutView, readOrEdit){			

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.startScoresApp(classroomLayoutView, readOrEdit);
		
		},

		showClassroomEditActivities: function(classroomLayoutView, classroomId){

			TeacherAccount.TeacherApp.Classroom.EditActivities.Controller.showClassroomEditActivities(classroomLayoutView, classroomId);
			
		},

		showClassroomEditScores: function(classroomLayoutView, classroomId){			

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomEditScores(classroomLayoutView, classroomId);
		
		},

	}

})