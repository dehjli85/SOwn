//= require admin/admin

Admin.module("AdminApp", function(AdminApp, Admin, Backbone, Marionette, $, _){
	
	AdminApp.Controller = {

		startAdminApp: function(subapp, userType, id){
			var adminHomeLayoutView = AdminApp.Controller.showAdminHomeLayout();

			if(subapp == "users_index"){
				AdminApp.Controller.showUsersIndex(adminHomeLayoutView, userType);
			}
			else if(subapp == "metrics"){
				AdminApp.Controller.showMetrics(adminHomeLayoutView);
			}
			else if(subapp == "user_metrics"){
				AdminApp.Controller.showUserMetrics(adminHomeLayoutView, userType, id);
			}
			else if(subapp == "upload_roster"){
				AdminApp.Controller.showUploadRoster(adminHomeLayoutView);
			}
		},

		showLoginButton: function(){

			var loginFormView = new Admin.AdminApp.LoginFormView();

			Admin.rootView.mainRegion.show(loginFormView);		

		},

		logInWithGoogle: function(layoutView){

			console.log("requesting google sign in ");

			auth2.signIn({
					'prompt': 'select_account',
			}).then(function(){

				AdminApp.Controller.logInWithGoogleCallback(auth2.currentUser.get().getAuthResponse().id_token, layoutView);

			})
			
			// auth2.signIn({
			// 	'prompt': 'select_account',
			// }).then(function(){
			// 	console.log("requesting offline access");

			// 	auth2.currentUser.get().grantOfflineAccess().then(function(authResult){
			// 		console.log("offline access granted");
			// 		AdminApp.Controller.logInWithGoogleCallback(authResult, layoutView);
			// 	});
			// })

		},

		logInWithGoogleCallback: function(idToken, layoutView){

			var postUrl = "/admin/google_login_post"			

			var postData = "id_token=" + idToken;

			var jqxhr = $.post(postUrl, postData, function(){

			})
			.done(function(data) {

				console.log(data);

				if (data.login_response === 'success'){		    	
					
					Admin.navigate("users_index");
					var adminHomeLayoutView = AdminApp.Controller.showAdminHomeLayout();
					AdminApp.Controller.showUsersIndex(adminHomeLayoutView);

		    }
		    else{

					console.log(data);

		    	if (data.error === 'invalid-credentials') {
		    		layoutView.flashMessage({message_type: "error", error: "invalid-credentials", message: "Invalid Credentials. Try logging in again."});		    		
		    	}
		    	else if (data.error === 'unknown-authentication-error') {
		    		layoutView.flashMessage({message_type: "error", error: "unknown-authentication-error", message: "Unknown Authentication Error. Contact Dennis."});		    		
		    	}
		    	
		    }
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		showAdminHomeLayout: function(){
			var adminHomeLayoutView = new Admin.AdminApp.AdminHomeLayoutView();
			Admin.rootView.mainRegion.show(adminHomeLayoutView);			
			return adminHomeLayoutView;
		},

		showUsersIndex: function(adminHomeLayoutView, searchTerm){

			var model = new Backbone.Model({searchTerm: searchTerm})

			var userIndexComposite = new Admin.AdminApp.UserIndexCompositeView({model: model});
			adminHomeLayoutView.mainAdminHomeRegion.show(userIndexComposite);
					
		},

		showMetrics: function(adminHomeLayoutView){
			
			var getUrl = "/admin/summary_metrics";						

			var jqxhr = $.get(getUrl, function(){

			})
			.done(function(data) {

				console.log(data);

				if (data.status === 'success'){	

					var metricsLayoutView = new Admin.AdminApp.Metrics.MetricsLayoutView();
					adminHomeLayoutView.mainAdminHomeRegion.show(metricsLayoutView);
					
					//relabel student data for bar graph view, then display
					var cumStudentUserCounts = data.cumulative_student_user_counts;
					cumStudentUserCounts.map(function(d){d.x = d.week; d.y = d.count})

					var studentUsersCountModel = new Backbone.Model({data: cumStudentUserCounts, labels:{x: "Week", y: "Student Users"}});

					var studentsBarGraph = new Admin.AdminApp.Metrics.BarGraph({model: studentUsersCountModel});
					metricsLayoutView.vizTwo.show(studentsBarGraph);

					studentsBarGraph.showBarGraph();

					//relabel student data for bar graph view, then display
					var cumTeacherUserCounts = data.cumulative_teacher_user_counts;
					cumTeacherUserCounts.map(function(d){d.x = d.week; d.y = d.count})

					var teacherUsersCountModel = new Backbone.Model({data: cumTeacherUserCounts, labels:{x: "Week", y: "Teacher Users"}});

					var teachersBarGraph = new Admin.AdminApp.Metrics.BarGraph({model: teacherUsersCountModel});
					metricsLayoutView.vizOne.show(teachersBarGraph);

					teachersBarGraph.showBarGraph();

					//relabel student performance data for bar graph view, then display
					var cumActivityCounts = data.cumulative_activity_counts;
					cumActivityCounts.map(function(d){d.x = d.week; d.y = d.count})

					var activityCountModel = new Backbone.Model({data: cumActivityCounts, labels:{x: "Week", y: "Activities"}});

					var activityBarGraph = new Admin.AdminApp.Metrics.BarGraph({model: activityCountModel});
					metricsLayoutView.vizThree.show(activityBarGraph);

					activityBarGraph.showBarGraph();

					//relabel student performance data for bar graph view, then display
					var cumStudentPerformanceCounts = data.cumulative_student_performance_counts;
					cumStudentPerformanceCounts.map(function(d){d.x = d.week; d.y = d.count})

					var studentPerformanceCountModel = new Backbone.Model({data: cumStudentPerformanceCounts, labels:{x: "Week", y: "Student Performances"}});

					var studentPerformanceBarGraph = new Admin.AdminApp.Metrics.BarGraph({model: studentPerformanceCountModel});
					metricsLayoutView.vizFour.show(studentPerformanceBarGraph);

					studentPerformanceBarGraph.showBarGraph();

		    }
		    else if (data.status == "error"){
	    		adminHomeLayoutView.flashMessage({message_type: "error", message: "Error: Unable to fetch summary metrics"});
		    }

	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

			
		},

		showUploadRoster: function(adminHomeLayoutView){
			var model = new Backbone.Model({
				student_errors: null,
				classroom_errors: null
			});
			var uploadRosterView = new AdminApp.UploadRosterView({model: model});
			adminHomeLayoutView.mainAdminHomeRegion.show(uploadRosterView);
		},

		uploadRoster: function(uploadRosterView, adminHomeLayoutView){
			var postUrl = "/admin/upload_roster";						
			// var postData = uploadRosterView.ui.rosterForm.serialize();
			var postData = new FormData();
			postData.append("roster_file", uploadRosterView.model.get("files")[0])
			// $.each(uploadRosterView.model.get("files"), function(key, value)
	  //   {
	  //       postData.append(key, value);
	  //   });

	    $.ajax({
        url: postUrl,
        type: 'POST',
        data: postData,
        cache: false,
        dataType: 'json',
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request
        success: function(data, textStatus, jqXHR){
					console.log(data);

          if (data.status === 'success'){		    
		    		adminHomeLayoutView.flashMessage({message_type: "success", message: "Roster successfully uploaded. " + data.student_count + " student accounts created."});
			    }
			    else if (data.status == "error"){
			    	
			    	uploadRosterView.model.set("student_errors", data.student_errors);
			    	uploadRosterView.model.set("classroom_errors", data.classroom_errors);
			    	uploadRosterView.render();

			    }
        },
        error: function(jqXHR, textStatus, errorThrown){
		  		console.log("error");
        }
    	});

		},

		searchUsers: function(userIndexComposite, searchForm, adminHomeLayoutView){

			var postUrl = "/admin/search_users";						
			var postData = searchForm.serialize();

			var jqxhr = $.post(postUrl, postData, function(){

			})
			.done(function(data) {

				console.log(data);

				if (data.status === 'success'){		    

					userIndexComposite.model.attributes.searchTerm = data.searchTerm
					userIndexComposite.render();

					userIndexComposite.collection = new Admin.Models.SearchResultsCollection(data.users);

					console.log(data.users);
					console.log(userIndexComposite.collection);

					userIndexComposite.render();

		    }
		    else if (data.status == "error"){
		    	if(data.message == "invalid-admin-user"){
		    		console.log("display error message")
		    		adminHomeLayoutView.flashMessage({message_type: "error", message: "Error: You are not logged in as in Admin User"});
		    	}
		    }

	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		becomeUser: function(userModel, adminHomeLayoutView){

			var postUrl = "admin/become_user";
			var postData = "user_id=" + userModel.attributes.id + "&user_type=" + userModel.attributes.user_type

			var jqxhr = $.post(postUrl, postData, function(){

			})
			.done(function(data) {

				if (data.status == 'success'){	

					adminHomeLayoutView.flashMessage({message_type: "success", message: "Session variable set.  Click <a href='/' target='_blank'>here</a> to proceed."});	    

					if(userModel.attributes.user_type == "teacher")
						window.open("teacher_home", "_blank");
					else if(userModel.attributes.user_type == "student")
						window.open("student_home", "_blank");

		    }
		    else if (data.status == "error"){
		    	if(data.message == "invalid-admin-user"){
		    		console.log("display error message")
		    		adminHomeLayoutView.flashMessage({message_type: "error", message: "Error: You are not logged in as in Admin User"});
		    	}
		    }
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		showUserMetrics: function(adminHomeLayoutView, userType, userId ){

			Admin.navigate("user_metrics/" + userType + "/" + userId);
			var getUrl = "/admin/user_metrics?id=" + userId + "&userType=" + userType;						

			var jqxhr = $.get(getUrl, function(){

			})
			.done(function(data) {

				console.log(data);

				if (data.status === 'success'){	

					
					if(userType == "teacher"){

						var userModel = new Backbone.Model({display_name: data.teacher.display_name, user_type: "Teacher"});
						var userMetricsLayoutView = new Admin.AdminApp.Metrics.UserMetricsLayoutView({model:userModel});
						adminHomeLayoutView.mainAdminHomeRegion.show(userMetricsLayoutView);
					

						//Display classroom count
						var classroomCountModel = new Backbone.Model({label: "Classrooms", number: data.classroom_counts});

						var classroomNumberPanel = new Admin.AdminApp.Metrics.NumberPanelView({model: classroomCountModel});
						userMetricsLayoutView.vizOne.show(classroomNumberPanel);

						//Display activity count
						var activityCountModel = new Backbone.Model({label: "Activities", number: data.activity_counts});

						var activityNumberPanel = new Admin.AdminApp.Metrics.NumberPanelView({model: activityCountModel});
						userMetricsLayoutView.vizTwo.show(activityNumberPanel );

						//Display student user count
						var studentUsersCountModel = new Backbone.Model({label: "Students", number: data.student_user_counts});

						var studentsNumberPanel = new Admin.AdminApp.Metrics.NumberPanelView({model: studentUsersCountModel});
						userMetricsLayoutView.vizThree.show(studentsNumberPanel);

						//Display student performance counts
						var studentPerformanceCountModel = new Backbone.Model({label: "Student Performances", number: data.student_performance_counts});

						var studentPerformanceNumberPanel = new Admin.AdminApp.Metrics.NumberPanelView({model: studentPerformanceCountModel});
						userMetricsLayoutView.vizFour.show(studentPerformanceNumberPanel);

					}
					else if (userType == "student"){
					
						var userModel = new Backbone.Model({display_name: data.student.display_name, user_type: "Student"});
						var userMetricsLayoutView = new Admin.AdminApp.Metrics.UserMetricsLayoutView({model:userModel});
						adminHomeLayoutView.mainAdminHomeRegion.show(userMetricsLayoutView);

						//Display classroom count
						var classroomCountModel = new Backbone.Model({label: "Classrooms", number: data.classroom_counts});

						var classroomNumberPanel = new Admin.AdminApp.Metrics.NumberPanelView({model: classroomCountModel});
						userMetricsLayoutView.vizOne.show(classroomNumberPanel);

						//Display student performance counts
						var studentPerformanceCountModel = new Backbone.Model({label: "Student Performances", number: data.student_performance_counts});

						var studentPerformanceNumberPanel = new Admin.AdminApp.Metrics.NumberPanelView({model: studentPerformanceCountModel});
						userMetricsLayoutView.vizTwo.show(studentPerformanceNumberPanel);

					}
					

		    }
		    else if (data.status == "error"){
	    		adminHomeLayoutView.flashMessage({message_type: "error", message: "Error: Unable to fetch summary metrics"});
		    }

	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		openChangePasswordModal: function(userView){

			var changePasswordModalView = new Admin.AdminApp.ChangePasswordModalView({model: userView.model});
			console.log(Admin.rootView)

			Admin.rootView.modalRegion.show(changePasswordModalView);

			Admin.rootView.ui.modalDiv.modal("show");
		},

		updatePassword: function(layoutView, changePasswordModalView){

			var postUrl = "admin/update_password"
			var postData = changePasswordModalView.ui.passwordForm.serialize();

			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made to save student settings');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					layoutView.ui.modalDiv.modal("hide");
					
					var alertModel = new Backbone.Model({message: "Password for " + changePasswordModalView.model.get("display_name") + " has been saved.", message_type: "success"})
					var alertView = new Admin.AdminApp.AlertView({model: alertModel});

					layoutView.alertRegion.show(alertView);					

				}
				else if(data.status == "error"){

					changePasswordModalView.ui.alertDiv.addClass("alert alert-danger");
					changePasswordModalView.ui.alertDiv.html("Error saving password...")

				}
	     	
	     	

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		}
		
	}	

});