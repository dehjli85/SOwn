//= require teacher/teacher

TeacherAccount.module("TeacherApp", function(TeacherApp, TeacherAccount, Backbone, Marionette, $, _){
	TeacherApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"classrooms": "showClassroomOverviews",
			"classroom/:id": "showClassroomScores"
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
			
			TeacherApp.Main.Controller.showClassroomScores(id);
			
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