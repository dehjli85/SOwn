//= require admin/admin

Admin.module("AdminApp", function(AdminApp, Admin, Backbone, Marionette, $, _){
	
	AdminApp.Controller = {

		showLoginButton: function(){

			var mainView = new Admin.AdminApp.MainView();

			Admin.rootView.mainRegion.show(mainView);		

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
					AdminApp.Controller.showUsersIndex();

		    }
		    else{
		    	if (data.error === 'invalid-credentials') {
		    		layoutView.flashErrorMessage({message_type: "error", error: "invalid-credentials", message: "Invalid Credentials. Try logging in again."});		    		

		    	}
		    	
		    }
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		showUsersIndex: function(){

			var model = new Backbone.Model({searchTerm: null})

			var userIndexComposite = new Admin.AdminApp.UserIndexCompositeView({model: model});
			Admin.rootView.mainRegion.show(userIndexComposite);
					
		},

		searchUsers: function(userIndexComposite, searchForm, adminLayoutView){

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
		    		adminLayoutView.flashErrorMessage({message_type: "error", message: "Error: You are not logged in as in Admin User"});
		    	}
		    }

	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		becomeUser: function(userModel, adminLayoutView){

			var postUrl = "admin/become_user";
			var postData = "user_id=" + userModel.attributes.id + "&user_type=" + userModel.attributes.user_type

			var jqxhr = $.post(postUrl, postData, function(){

			})
			.done(function(data) {

				if (data.status == 'success'){		    

					if(userModel.attributes.user_type == "teacher")
						window.open("teacher_home", "_blank");
					else if(userModel.attributes.user_type == "student")
						window.open("student_home", "_blank");

		    }
		    else if (data.status == "error"){
		    	if(data.message == "invalid-admin-user"){
		    		console.log("display error message")
		    		adminLayoutView.flashErrorMessage({message_type: "error", message: "Error: You are not logged in as in Admin User"});
		    	}
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