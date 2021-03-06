//= require student/student

StudentAccount.module("StudentApp", function(StudentApp, StudentAccount, Backbone, Marionette, $, _){
	StudentApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"classrooms": "startClassroomsApp",			
			"classroom/scores/:id": "showClassroomScores",
			"settings": "startSettingsApp"
		}
	});

	var API = {		
		showHeaderAndLeftNavViews: function(){
			StudentApp.Main.Controller.showHeaderAndLeftNavViews();			
		},

		/**
		 *	Classrooms Subapp
		 */

		startClassroomsApp: function(){
			StudentApp.Classrooms.Controller.startClassroomsApp();			
		},

		/**
		 *	Classroom Subapp
		 */

		showClassroomScores: function(id){
			StudentApp.Main.Controller.showHeaderAndLeftNavViews();			
			StudentApp.Main.Controller.startClassroomApp(id, "scores");			
		},

		/**
		 * Settings Subapp
		 */

		startSettingsApp: function(){
			StudentApp.Main.Controller.showHeaderAndLeftNavViews();			
			StudentApp.Settings.Controller.showSettingsOptions();
		}

	};

	StudentAccount.on("classrooms", function(){
		StudentAccount.navigate("classrooms");
		API.startClassroomsApp();
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