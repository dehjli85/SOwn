//= require teacher/teacher

TeacherAccount.module("TeacherApp", function(TeacherApp, TeacherAccount, Backbone, Marionette, $, _){
	TeacherApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"classrooms": "showClassroomOverviews",
			"classrooms/new": "showClassroomNew",
			"classroom/scores/:id": "showClassroomScores",
			"classroom/edit_activities/:id": "showClassroomEditActivities",
			"activities/index": "showActivitiesIndex",
			"activities/new": "showActivitiesNew",
			"activities/:id/edit": "showActivitiesEdit"
		}
	});

	var API = {		
		showHeaderAndLeftNavViews: function(){
			TeacherApp.Main.Controller.showHeaderAndLeftNavViews();			
		},

		/**
		 *	Classrooms Subapp
		 */

		showClassroomOverviews: function(){
			TeacherApp.Classrooms.Controller.showClassroomOverviews();			
		},

		showClassroomNew: function(){
			TeacherApp.Classrooms.Controller.showClassroomNew();
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
		}

	};

	TeacherAccount.on("classrooms", function(){
		console.log("heard classrooms");
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