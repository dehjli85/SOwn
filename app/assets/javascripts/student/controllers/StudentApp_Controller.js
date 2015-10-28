//= require student/student

StudentAccount.module("StudentApp.Main", function(Main, StudentAccount, Backbone, Marionette, $, _){

	Main.Controller = {

		showHeaderAndLeftNavViews: function(){

			//get user model data and create the header
			var jqxhr = $.get("/current_user", function(){
				console.log('get request made for student user data');
			})
			.done(function(data) {
				console.log(data);
	     	//fetch user model and create header
	     	var user = new StudentAccount.Models.StudentUser({student:data.student, teacher: data.teacher});
				var headerView = new StudentAccount.StudentApp.HeaderView({model:user});				
				StudentAccount.rootView.headerRegion.show(headerView);

				// if the student_user in the session is a google user
				if(user.get("student").provider != null){

					// if the user is logged in with google, create a listener that logs them out if they sign out of google
					 gapi.load('auth2', function() {

			      auth2 = gapi.auth2.init({
			        client_id: '916932200710-kk91r5rbn820llsernmbjfgk9r5s67lq.apps.googleusercontent.com',
			      }).then(function(){

			      	auth2 = gapi.auth2.getAuthInstance();

			      	var currentUserEmail = auth2.currentUser.get().getBasicProfile() ? auth2.currentUser.get().getBasicProfile().getEmail() : null;
			      	if(!currentUserEmail || !currentUserEmail.endsWith("@sowntogrow.com")){
			      		// check that they are signed into google with the right google account
				      	if(!auth2.isSignedIn.get() || auth2.currentUser.get().getId() != user.get("student").uid){
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
							
				    });
			    });
		
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