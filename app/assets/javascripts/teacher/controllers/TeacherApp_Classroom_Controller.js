//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom", function(Classroom, TeacherAccount, Backbone, Marionette, $, _){

	Classroom.Controller = {

		showClassroomLayout: function(classroomId){
			var layoutView = new TeacherAccount.TeacherApp.Classroom.LayoutView();			
			TeacherAccount.rootView.mainRegion.show(layoutView);

			return layoutView;
		},

		showClassroomHeader: function(classroomLayoutView, id, subapp){

			var jqxhr = $.get("/teacher/classroom?id=" + id, function(){
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

		showClassroomScores: function(classroomLayoutView, classroomId){			

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomScores(classroomLayoutView, classroomId);
		
		},

		showClassroomEditActivities: function(classroomLayoutView, classroomId){

			TeacherAccount.TeacherApp.Classroom.EditActivities.Controller.showClassroomEditActivities(classroomLayoutView, classroomId);
			
		},

		showClassroomEditScores: function(classroomLayoutView, classroomId){			

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomEditScores(classroomLayoutView, classroomId);
		
		},

	}

})