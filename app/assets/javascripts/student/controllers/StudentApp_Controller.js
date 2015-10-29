//= require student/student

StudentAccount.module("StudentApp.Main", function(Main, StudentAccount, Backbone, Marionette, $, _){

	Main.Controller = {

		showHeaderAndLeftNavViews: function(){

			//get user model data and create the header
			var jqxhr = $.get("/current_user", function(){
				console.log('get request made for student user data');
			})
			.done(function(data) {
				
				// Record ID and email for full story
				FS.identify('s' + data.student.id, {
				  displayName: data.student.display_name,
				  email: data.student.email
				});

				FS.setUserVars({
				  userType: 'student'
			  });

	     	//fetch user model and create header
	     	var user = new StudentAccount.Models.StudentUser({student:data.student, teacher: data.teacher});
				var headerView = new StudentAccount.StudentApp.HeaderView({model:user});				
				StudentAccount.rootView.headerRegion.show(headerView);
				

				// create the left nav
				var jqxhr = $.get("/student/classrooms_summary", function(){
					console.log('get request made for student classrooms data');
				})
				.done(function(data) {

					// create the left nav
					var leftNavModel = new Backbone.Model({classrooms: data.classrooms});
					var leftNav = new StudentAccount.StudentApp.LeftNavView({model:leftNavModel});
					StudentAccount.rootView.leftNavRegion.show(leftNav);
					
			  })
			  .fail(function() {
			  	console.log("error");
			  })
			  .always(function() {
			   
				});
				
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

			if(StudentAccount.rootView.leftNavRegion.currentView)
				StudentAccount.rootView.leftNavRegion.currentView.openClassroomSubmenu(classroomId);

			
		},

		showTeacherView: function(){
			window.location.replace("teacher_home");
		}
	
	}

});