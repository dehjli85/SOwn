//= require teacher/teacher

TeacherAccount.module("TeacherApp.Main", function(Main, TeacherAccount, Backbone, Marionette, $, _){

	Main.Controller = {

		showHeaderAndLeftNavViews: function(){

			//get user model data and create the header
			var jqxhr = $.get("/current_teacher_user", function(){
				console.log('get request made');
			})
			.done(function(data) {
	     	
	     	//fetch user model and create header
	     	var user = new TeacherAccount.Models.TeacherUser(data);
				var headerView = new TeacherAccount.TeacherApp.HeaderView({model:user});				
				TeacherAccount.rootView.headerRegion.show(headerView);

				// create the left nav
				var leftNav = new TeacherAccount.TeacherApp.LeftNavView();
				TeacherAccount.rootView.leftNavRegion.show(leftNav);
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		showClassroomScores: function(classroomId){
			
			TeacherAccount.navigate("classroom/" + classroomId);

			//create the layout for the classroom sub-app
			var layoutView = new TeacherAccount.TeacherApp.Classroom.LayoutView();			
			TeacherAccount.rootView.mainRegion.show(layoutView);

			//show the header for the sub-app
			TeacherAccount.TeacherApp.Classroom.Controller.showClassroomHeader(layoutView, classroomId, 'scores');

			//show the other parts of the classroom scores page
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomScores(layoutView, classroomId)
		}
	}

});