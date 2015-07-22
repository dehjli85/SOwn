//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Login", function(Login, PublicPages, Backbone, Marionette, $, _){
	
	Login.Controller = {

		showLoginForm: function(flashMessageModel){
			console.log("show login form");
			var layoutView = new PublicPages.SignUpAndLoginApp.Login.Layout();			
			

			var flashMessageView = new PublicPages.SignUpAndLoginApp.Login.FlashMessageRegion({model: flashMessageModel});
			var loginForm = new PublicPages.SignUpAndLoginApp.Login.LoginFormRegion();

			layoutView.on("show", function(){
				layoutView.loginFormRegion.show(loginForm);	
				if(flashMessageModel)
					layoutView.flashMessageRegion.show(flashMessageView);
			});



			PublicPages.mainRegion.show(layoutView);		

			loginForm.on("login:sign-in", function(args){
				console.log("posting ajax request");
				// PublicPages.SignUpAndLoginApp.Login.Controller.postLoginCredentials();
				var jqxhr = $.post( "/login_post", args.view.ui.credentialsForm.serialize(), function() {
				  console.log("login post made");
				})
			  .done(function(data) {
		    	// console.log("successful response");
		     	console.log(data);
			    if (data.login_response === 'success'){
			    	if (data.user_type === 'teacher') {
			    		//redirect to teacher homepage
			    		window.location.replace("teacher_home");
			    	}
			    	else if (data.user_type === 'student') {
			    		//redirect to the student homepage
			    		window.location.replace("student_home");
			    	}
			    }
			    else{
			    	if (data.error === 'invalid-credentials') {
			    		layoutView.flashErrorMessage({message_type: "error", error: "invalid-credentials", message: "Invalid Credentials. Try logging in again."});
			    		

			    	}
			    	else if (data.error === 'post-login-with-oauth-credentials') {
			    		layoutView.flashErrorMessage({message_type: "error",error: "post-login-with-oauth-credentials", message: "You're account was setup through Google Sign-In.  Please try log in through your Google account."});			    		
			    		
			    		
			    	}
			    }
			  })
			  .fail(function() {
			  	console.log('failure occured');
			  	
			  	layoutView.flashErrorMessage({message_type: "error", error: "unexpected-error", message: "An unexpected error occurred when trying to login."});			  				  	
			  	
			  })
			  .always(function() {
			    //don't need to do anything here
				});
			});
			
		},

		

	}
	
});
