//= require teacher/teacher

TeacherAccount.module("TeacherApp", function(TeacherApp, TeacherAccount, Backbone, Marionette, $, _){
	TeacherApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"classrooms": "showClassroomOverviews",
			"classroom/new": "showClassroomNew",
			"classroom/scores/:id": "showClassroomScores",
			"classroom/edit_scores/:id": "showClassroomEditScores",
			"classroom/edit_activities/:id": "showClassroomEditActivities",
			"classroom/edit_classroom/:id": "showClassroomEditClassroom",
			"activities/index": "showActivitiesIndex",
			"activities/new": "showActivitiesNew",
			"activities/:id/edit": "showActivitiesEdit",
			"students/index": "showStudentsIndex",
			"students/show/:student_user_id/:classroom_id": "showStudent",
			"students/show/": "showStudent",
			"settings": "showSettings"
		}
	});

	var API = {		
		showHeaderAndLeftNavViews: function(){
			var subapp;
			if(TeacherAccount.getCurrentRoute().match("classrooms") != null){
				subapp = "classrooms"
			}
			else if(TeacherAccount.getCurrentRoute().match("classroom/") != null){
				subapp = "classroom"		
			}
			else if(TeacherAccount.getCurrentRoute().match("activities/") != null){
				subapp = "activities"		
			}
			TeacherApp.Main.Controller.showHeaderAndLeftNavViews(subapp);			
		},

		/**
		 *	Classrooms Subapp
		 */

		showClassroomOverviews: function(){
			TeacherApp.Classrooms.Controller.showClassroomOverviews();			
		},

		showClassroomNew: function(){
			TeacherApp.Main.Controller.showClassroomNew();
		},

		/**
		 *	Classroom Subapp
		 */

		showClassroomScores: function(id){			
			TeacherApp.Main.Controller.startClassroomApp(id, 'scores');			
		},

		showClassroomEditActivities: function(id){
			TeacherApp.Main.Controller.startClassroomApp(id, 'edit_activities');	
		},

		showClassroomEditScores: function(id){			
			TeacherApp.Main.Controller.startClassroomApp(id, 'edit_scores');			
		},

		showClassroomEditClassroom: function(id){
			TeacherApp.Main.Controller.startClassroomApp(id, 'edit_classroom');
		},


		/**
		 *	Activities Subapp
		 */
		showActivitiesIndex: function(){
			TeacherApp.Main.Controller.startActivitiesApp('index');
		},

		showActivitiesNew: function(){
			TeacherApp.Main.Controller.startActivitiesApp('new');
		},

		showActivitiesEdit: function(id){
			TeacherApp.Main.Controller.startActivitiesApp('edit', id);
		},

		/**
		 *  Settings Subapp
		 */

		 showSettings: function(){
		 	TeacherApp.Main.Controller.startSettingsApp();
		 },


		/**
		 *  Students Subapp
		 */

		 showStudentsIndex: function(){
		 	TeacherApp.Main.Controller.startStudentsApp("index");
		 },

		 showStudent: function(student_user_id, classroom_id){
		 	TeacherApp.Main.Controller.startStudentsApp("show", student_user_id, classroom_id);
		 }


	};

	TeacherAccount.on("classrooms", function(){
		TeacherAccount.navigate("classrooms");
		API.showClassroomOverviews();
	})



	TeacherAccount.on("header-and-leftnav", function(){
		API.showHeaderAndLeftNavViews();
	});

	TeacherAccount.addInitializer(function(){
		new TeacherApp.Router({
			controller: API
		});

		TeacherAccount.rootView = new TeacherAccount.TeacherApp.LayoutView();
		TeacherAccount.rootView.render();

	});
});