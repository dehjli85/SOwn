//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Login", function(Login, PublicPages, Backbone, Marionette, $, _){
	
	Login.Controller = {

		showLoginForm: function(flashMessageModel){

			PublicPages.navigate("login");
			
			var loginLayoutView = new PublicPages.SignUpAndLoginApp.Login.Layout();			
			PublicPages.rootView.mainRegion.show(loginLayoutView);		

			var flashMessageView = new PublicPages.SignUpAndLoginApp.Login.FlashMessageRegion({model: flashMessageModel});
			var loginForm = new PublicPages.SignUpAndLoginApp.Login.LoginFormRegion();

			loginLayoutView.loginFormRegion.show(loginForm);	
			if(flashMessageModel)
				loginLayoutView.flashMessageRegion.show(flashMessageView);
		
		},

		postLogin: function(loginFormView, loginLayoutView){

			loginLayoutView.clearMessages();
			PublicPages.rootView.alertRegion.empty();

			//record the email address in full story they are trying to log in with
			FS.setUserVars({
			  displayName: 'User Logging In: ' + loginFormView.ui.emailInput.val(),
			  email: loginFormView.ui.emailInput.val()
			});

			var jqxhr = $.post( "/login_post", loginFormView.ui.credentialsForm.serialize(), function() {
			  console.log("login post made");
			})
		  .done(function(data) {
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
		    		loginLayoutView.flashErrorMessage({message_type: "error", error: "invalid-credentials", message: "Invalid Credentials. Try logging in again."});
		    		

		    	}
		    	else if (data.error === 'post-login-with-oauth-credentials') {
		    		loginLayoutView.flashErrorMessage({message_type: "error",error: "post-login-with-oauth-credentials", message: "You're account was setup through Google Sign-In.  Please try log in through your Google account."});			    		
		    		
		    		
		    	}
		    }
		  })
		  .fail(function() {
		  	console.log('failure occured');
		  	
		  	loginLayoutView.flashErrorMessage({message_type: "error", error: "unexpected-error", message: "An unexpected error occurred when trying to login."});			  				  	
		  	
		  })
		  .always(function() {
		    //don't need to do anything here
			});
		},

		logInWithGoogle: function(loginLayoutView){

			var startTime = moment();
			var firstTime = true;
			while(typeof auth2 == 'undefined' && moment() - startTime < 2000){
				if(firstTime){
					console.log("waiting for gapi to load");
					firstTime = false;
				}
			}

			if(typeof auth2 == 'undefined'){
    		loginLayoutView.flashErrorMessage({
    			message_type: "error",
    			error: "post-login-with-stg-credentials", 
    			message: "There was an error communicating with Google.  Click the log in button again, or reload this page and try again."});			    		

			}else{
				console.log("requesting offline access");
				auth2.signIn({'prompt': 'select_account'}).then(function(){
					auth2.grantOfflineAccess({
						'redirect_uri': 'postmessage',
						'prompt': 'select_account'
					}).then(function(authResult){
						PublicPages.SignUpAndLoginApp.Login.Controller.logInCallback(authResult, loginLayoutView);
					});		
				})
				
			}

			

		},

		logInCallback: function(authResult, loginLayoutView){

			var postUrl = "/google_login_post"
			var postData = "authorization_code=" + authResult.code;

			//record the email address in full story they are trying to log in with
    	var currentUserEmail = auth2.currentUser.get().getBasicProfile() ? auth2.currentUser.get().getBasicProfile().getEmail() : null;
			FS.setUserVars({
			  displayName: 'User Logging In: ' + currentUserEmail,
			  email: currentUserEmail
			});

			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made with authorization code');
			})
			.done(function(data) {

				if (data.login_response === 'success'){
		    	if (data.user_type === 'teacher') {

						ga('send', 'event', 'public_pages', 'google_login', 'teacher');

		    		//redirect to teacher homepage
		    		window.location.replace("teacher_home");
		    	}
		    	else if (data.user_type === 'student') {
		    		//redirect to the student homepage
						
						ga('send', 'event', 'public_pages', 'google_login', 'student');

		    		window.location.replace("student_home");
		    	}
		    }
		    else{
		    	if (data.error === 'invalid-credentials') {
		    		loginLayoutView.flashErrorMessage({message_type: "error", error: "invalid-credentials", message: "Invalid Credentials. You might be signed into Google with the wrong account.  Sign out at <a href='http://www.google.com' target='_blank'>google.com</a> and try logging in again."});
		    		

		    	}
		    	else if (data.error === 'post-login-with-stg-credentials') {
		    		loginLayoutView.flashErrorMessage({message_type: "error",error: "post-login-with-stg-credentials", message: "You're Google account email address was used to create a Sown To Grow acocunt.  Please try log in with the Sown To Grow account."});			    		
		    				    		
		    	}
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
