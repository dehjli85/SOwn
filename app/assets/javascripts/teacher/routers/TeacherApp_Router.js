//= require teacher/teacher

TeacherAccount.module("TeacherApp", function(TeacherApp, TeacherAccount, Backbone, Marionette, $, _){
	TeacherApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"classrooms": "showClassroomOverviews",
			"classroom/scores/:id": "showClassroomScores",
			"classroom/edit_activities/:id": "showClassroomEditActivities",
			"activities/index": "showActivitiesIndex"
		}
	});

	var API = {		
		showHeaderAndLeftNavViews: function(){
			TeacherApp.Main.Controller.showHeaderAndLeftNavViews();			
		},

		showClassroomOverviews: function(){
			TeacherApp.Classrooms.Controller.showClassroomOverviews();			
		},

		showClassroomScores: function(id){			
			// var layoutView = TeacherApp.Main.Controller.showClassroomLayout(id);
			TeacherApp.Main.Controller.startClassroomApp(id, 'scores');			
		},

		showClassroomEditActivities: function(id){
			TeacherApp.Main.Controller.startClassroomApp(id, 'edit_activities');	
		},

		showActivitiesIndex: function(){
			TeacherApp.Main.Controller.startActivitiesApp('index');
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