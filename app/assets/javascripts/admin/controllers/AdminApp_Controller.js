//= require admin/admin

Admin.module("AdminApp", function(AdminApp, Admin, Backbone, Marionette, $, _){
	
	AdminApp.Controller = {

		startAdminApp: function(subapp, userType, id){
			var adminHomeLayoutView = AdminApp.Controller.showAdminHomeLayout();

			if(subapp == "users_index"){
				AdminApp.Controller.showUsersIndex(adminHomeLayoutView);
			}
			else if(subapp == "metrics"){
				AdminApp.Controller.showMetrics(adminHomeLayoutView);
			}
			else if(subapp == "user_metrics"){
				AdminApp.Controller.showUserMetrics(adminHomeLayoutView, userType, id);
			}
		},

		showLoginButton: function(){

			var loginFormView = new Admin.AdminApp.LoginFormView();

			Admin.rootView.mainRegion.show(loginFormView);		

		},

		logInWithGoogle: function(layoutView){
			auth2.grantOfflineAccess({'redirect_uri': 'postmessage'}).then(function(authResult){
				AdminApp.Controller.logInWithGoogleCallback(authResult, layoutView);
			});
		},

		logInWithGoogleCallback: function(authResult, layoutView){

			var postUrl = "/admin/google_login_post"			

			var postData = "authorization_code=" + authResult.code;

			var jqxhr = $.post(postUrl, postData, function(){

			})
			.done(function(data) {


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

		showUsersIndex: function(adminHomeLayoutView){

			var model = new Backbone.Model({searchTerm: null})

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
	    		adminHomeLayoutView.flashErrorMessage({message_type: "error", message: "Error: Unable to fetch summary metrics"});
		    }

	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
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

					userIndexComposite.collection = new Backbone.Collection(data.users);
					userIndexComposite.render();

		    }
		    else if (data.status == "error"){
		    	if(data.message == "invalid-admin-user"){
		    		console.log("display error message")
		    		adminHomeLayoutView.flashErrorMessage({message_type: "error", message: "Error: You are not logged in as in Admin User"});
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
	    		adminHomeLayoutView.flashErrorMessage({message_type: "error", message: "Error: Unable to fetch summary metrics"});
		    }

	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

	}	

});