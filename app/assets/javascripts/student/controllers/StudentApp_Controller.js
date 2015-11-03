//= require student/student

StudentAccount.module("StudentApp.Main", function(Main, StudentAccount, Backbone, Marionette, $, _){

	Main.Controller = {

		setSignOutListener: function(uid){

			// if the auth2 isn't ready, set a timeout in 1 second to wait and try again
			if(typeof auth2 == 'undefined'){
				console.log("auth2 not ready... waiting...")
				setTimeout(function(){Main.Controller.setSignOutListener(uid);},1000);
			}
			else{
				var currentUserEmail = auth2.currentUser.get().getBasicProfile() ? auth2.currentUser.get().getBasicProfile().getEmail() : null;
	      	
      	if(currentUserEmail == null){
      		Main.Controller.logout(false);
      	}
      	
      	else if(currentUserEmail.indexOf("@sowntogrow.com") == -1){
      		
      		// check that they are signed into google with the right google account
	      	if(!auth2.isSignedIn.get() || auth2.currentUser.get().getId() != uid){
						Main.Controller.logout(false);		        		
	      	}

	      	// create a listener for if they sign out of google
	      	auth2.isSignedIn.listen(function(signedIn){
		      	console.log("authentication state has changed");
		        if(!signedIn){				        	
							Main.Controller.logout(true);		        		
		        }
		      });
      	}
			}
			
		},

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
				

				// if the student_user in the session is a google user
				if(user.get("student").provider != null){
					Main.Controller.setSignOutListener(user.get("student").uid);
				}

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
		},

		logout: function(showErrorMessage){

			// get request to clear sessions variables and redirect to login page
			var getUrl = "/signout_json";
			var jqxhr = $.get(getUrl, function() {
			  console.log("get request to sign out");
			})
		  .done(function(data) {
		    if (data.status === 'success'){			    	
		    	if(showErrorMessage){
	    			window.location.replace("/#login/loggedOut");
		    	}
		    	else{
	    			window.location.replace("/#login");
		    	}
		    }
		  })
		  .fail(function() {
		  	//need to handle the connection error
		   console.log("error");
		  })
		  .always(function() {
		   
			});
		}
	
	}

});