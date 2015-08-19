//= require student/student

StudentAccount.module("StudentApp.Main", function(Main, StudentAccount, Backbone, Marionette, $, _){

	Main.Controller = {

		showHeaderAndLeftNavViews: function(){

			//get user model data and create the header
			var jqxhr = $.get("/current_user", function(){
				console.log('get request made for student user data');
			})
			.done(function(data) {

	     	//fetch user model and create header
	     	var user = new StudentAccount.Models.StudentUser({student:data.student, teacher: data.teacher});
				var headerView = new StudentAccount.StudentApp.HeaderView({model:user});				
				StudentAccount.rootView.headerRegion.show(headerView);

				// create the left nav
				var leftNav = new StudentAccount.StudentApp.LeftNavView();
				StudentAccount.rootView.leftNavRegion.show(leftNav);
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		startClassroomApp: function(classroomId, subapp){

			//THIS LINE IS NECESSARY BECAUSE THE D3 WIDGET IS BREAKING NORMAL <A> HREF BEHAVIOR
			//DO NOT DELETE
			StudentAccount.navigate('classroom/' + subapp + '/' + classroomId);

			var classroomLayout = StudentAccount.StudentApp.Classroom.Controller.showClassroomLayout(classroomId);

			StudentAccount.StudentApp.Classroom.Controller.showClassroomHeader(classroomLayout,classroomId, subapp);

			if (subapp === 'scores'){				

				StudentAccount.StudentApp.Classroom.Controller.showClassroomScores(classroomLayout,classroomId);	

			}
			else if (subapp === 'edit_activities'){

				StudentAccount.StudentApp.Classroom.Controller.showClassroomEditActivities(classroomLayout,classroomId);	

			}
			else if (subapp === 'edit_scores'){

				StudentAccount.StudentApp.Classroom.Controller.showClassroomEditScores(classroomLayout,classroomId);	

			}
			
		},

		showTeacherView: function(){
			window.location.replace("teacher_home");
		}
	
	}

});