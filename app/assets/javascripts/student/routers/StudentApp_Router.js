//= require student/student

StudentAccount.module("StudentApp", function(StudentApp, StudentAccount, Backbone, Marionette, $, _){
	StudentApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"classrooms": "showClassroomOverviews",			
			"classroom/scores/:id": "showClassroomScores"
		}
	});

	var API = {		
		showHeaderAndLeftNavViews: function(){
			StudentApp.Main.Controller.showHeaderAndLeftNavViews();			
		},

		/**
		 *	Classrooms Subapp
		 */

		showClassroomOverviews: function(){
			StudentApp.Classrooms.Controller.showClassroomOverviews();			
		},

		/**
		 *	Classroom Subapp
		 */

		showClassroomScores: function(id){
			StudentApp.Main.Controller.startClassroomApp(id, "scores");			
		},

	};

	StudentAccount.on("classrooms", function(){
		StudentAccount.navigate("classrooms");
		API.showClassroomOverviews();
	})



	StudentAccount.on("header-and-leftnav", function(){
		API.showHeaderAndLeftNavViews();
	});

	StudentAccount.addInitializer(function(){
		new StudentApp.Router({
			controller: API
		});

		StudentAccount.rootView = new StudentAccount.StudentApp.LayoutView();
		StudentAccount.rootView.render();

	});
});