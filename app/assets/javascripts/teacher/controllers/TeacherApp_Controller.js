//= require teacher/teacher

TeacherAccount.module("TeacherApp.Main", function(Main, TeacherAccount, Backbone, Marionette, $, _){

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


		showHeaderAndLeftNavViews: function(subapp){

			//get user model data and create the header
			var jqxhr = $.get("/current_user", function(){
				console.log('get request made for teacher user data');
			})
			.done(function(data) {
	     	
	     	// Record ID and email for full story
				FS.identify('t' + data.teacher.id, {
				  displayName: data.teacher.display_name,
				  email: data.teacher.email
				});

				FS.setUserVars({
				  userType: 'teacher'
			  });

	     	//fetch user model and create header
	     	var user = new Backbone.Model({teacher: data.teacher, student: data.student});
				

				// if the student_user in the session is a google user
				if(user.get("teacher").provider != null){
					Main.Controller.setSignOutListener(user.get("teacher").uid);
				}


				// create the left nav
				var jqxhr = $.get("/classrooms_summary", function(){
					console.log('get request made for teacher classrooms data');
				})
				.done(function(data2) {


					// create the left nav
					var model = new Backbone.Model({subapp: subapp, classrooms: data2.classrooms, teacher: data.teacher, student: data.student});
					var headerView = new TeacherAccount.TeacherApp.HeaderView({model:model});				
					TeacherAccount.rootView.headerRegion.show(headerView);
					
					
			  })
			  .fail(function() {
			  	console.log("error");
			  })
			  .always(function() {
			   
				});
				
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
			TeacherAccount.navigate('classroom/' + subapp + '/' + classroomId);

			var classroomLayoutView = TeacherAccount.TeacherApp.Classroom.Controller.showClassroomLayout(classroomId);

			TeacherAccount.TeacherApp.Classroom.Controller.showClassroomHeader(classroomLayoutView,classroomId, subapp);


			if (subapp === 'scores'){				

				TeacherAccount.TeacherApp.Classroom.Controller.startScoresApp(classroomLayoutView,"read");	

			}
			else if (subapp === 'edit_activities'){

				TeacherAccount.TeacherApp.Classroom.Controller.showClassroomEditActivities(classroomLayoutView,classroomId);	

			}
			else if (subapp === 'edit_scores'){

				TeacherAccount.TeacherApp.Classroom.Controller.startScoresApp(classroomLayoutView,"edit");	

			}
			else if(subapp === 'edit_classroom'){

				TeacherAccount.TeacherApp.Classroom.Controller.showEditClassroom(classroomLayoutView,classroomId);	
					
			}

			if(TeacherAccount.rootView.leftNavRegion.currentView)
				TeacherAccount.rootView.leftNavRegion.currentView.openClassroomSubmenu(classroomId);

			
		},

		startActivitiesApp: function(subapp, id){
			url = 'activities';
			if(id){
				url += "/" + id;
			}
			url += "/" + subapp;

			TeacherAccount.navigate(url);
			
			if( subapp === 'index'){
				TeacherAccount.TeacherApp.Activities.Controller.showActivitiesIndex();
			}
			else if(subapp === 'new'){
				TeacherAccount.TeacherApp.Activities.Controller.showNewActivity();
			}
			else if(subapp === 'edit'){
				TeacherAccount.TeacherApp.Activities.Controller.showEditActivity(id);	
			}

		},

		startSettingsApp: function(){

			TeacherAccount.navigate("settings");

			TeacherAccount.TeacherApp.Settings.Controller.showSettingsOptions();

		},

		showClassroomNew: function(layoutView){

			// TeacherAccount.navigate("classroom/new");			
			
			var classroom = new TeacherAccount.Models.Classroom({
				name: "",
				description: "",
				classroom_code: "",
				errors:{},
				editOrNew: "new"	
			});			

			var classroomView = new TeacherAccount.TeacherApp.ClassroomView({model:classroom});
			layoutView.ui.modalRegion.modal("show");
			layoutView.modalRegion.show(classroomView);
		},

		saveClassroom: function(classroomView, classroomModalContainerView){

			var postUrl;
			if(classroomView.model.attributes.editOrNew == "new"){
				postUrl = "teacher/save_new_classroom";	
			}else if(classroomView.model.attributes.editOrNew == "edit"){
				postUrl = "teacher/update_classroom";
			}
			
			var jqxhr = $.post(postUrl, classroomView.ui.classroomForm.serialize(), function(){
				console.log('post request to save new activity');
			})
			.done(function(data) {

				console.log(data);
				if(data.status == "success"){
					//show a success message, render the edit activity page
					// console.log("success")
					if(classroomView.model.attributes.editOrNew == "new"){
						
						classroomModalContainerView.ui.modalRegion.modal("hide");

						TeacherAccount.TeacherApp.Classrooms.Controller.showClassroomOverviews();


						var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Classroom successfully saved!"});
						var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
						TeacherAccount.navigate("classrooms") //has to be before show, because navigate clears the alerts
						TeacherAccount.rootView.alertRegion.show(alertView);
					}
					else if(classroomView.model.attributes.editOrNew == "edit"){
						var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Classroom successfully saved!"});
						var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
						TeacherAccount.rootView.alertRegion.show(alertView);

						classroomModalContainerView.ui.modalRegion.modal("hide");
						TeacherAccount.TeacherApp.Classroom.Controller.showClassroomHeader(classroomModalContainerView, classroomModalContainerView.model.get("classroomId"), 'scores');

					}
					
				}
				else{
					//show an error message
					classroomView.showErrors(data.errors);
				}

				
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	
		},

		showStudentView: function(){
			window.location.replace("student_home");
		},

		startStudentsApp: function(subapp, student_user_id, classroom_id){

			url = 'students';
			url += "/" + subapp;			
			if(student_user_id){
				url += "/" + student_user_id;
			}
			if(classroom_id){
				url += "/" + classroom_id;
			}

			TeacherAccount.navigate(url);

		 	console.log("classroom_id: " + classroom_id);

			
			if( subapp === 'index'){
				TeacherAccount.TeacherApp.Students.Controller.showIndexCompositeView();
			}
			else if(subapp === 'show'){
				var model = new Backbone.Model({});

				var studentsLayoutView = new TeacherAccount.TeacherApp.Students.StudentsLayoutView({model:model});
				TeacherAccount.rootView.mainRegion.show(studentsLayoutView);

				TeacherAccount.TeacherApp.Students.Controller.showStudentView(student_user_id, classroom_id);
			}
			else if(subapp === 'kiosk'){
				console.log("kiosk mode");
				TeacherAccount.TeacherApp.Students.Controller.showKioskMode();
			}
			

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