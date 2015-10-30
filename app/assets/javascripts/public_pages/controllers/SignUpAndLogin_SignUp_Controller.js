//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.SignUp", function(SignUp, PublicPages, Backbone, Marionette, $, _){
	
	SignUp.Controller = {

		showSignUpForm: function(userType){
			if(userType == "Teacher")
				PublicPages.navigate("sign_up_teacher");
			else if(userType == "Student")
				PublicPages.navigate("sign_up_student");

			var model = new Backbone.Model({user_type: userType})
			var signUpView = new PublicPages.SignUpAndLoginApp.SignUp.SignUpView({model: model});

			PublicPages.rootView.mainRegion.show(signUpView);

		},

		signUp: function(signUpView){

			signUpView.clearErrors();

			var postUrl;
			if(signUpView.model.attributes.user_type == "Teacher")
				postUrl = "/teacher_sign_up";
			else if(signUpView.model.attributes.user_type == "Student")
				postUrl = "/student_sign_up";

			var jqxhr = $.post( postUrl, signUpView.ui.signUpForm.serialize(), function() {
			  console.log("post_made");
			})
		  .done(function(data) {
	     	console.log(data);
		    if (data.status === 'success'){			    	

		    	var object = 
		    	{
		    		message_type: "success", 		    	
		    		message: "Account successfully created.  Please Login."
		    	};

		    	if(signUpView.model.attributes.user_type == "Teacher")
						object.success = "teacher-account-created";
					else if(signUpView.model.attributes.user_type == "Student")
						object.success = "student-account-created"; 

		    		
	    		
		    	PublicPages.SignUpAndLoginApp.Login.Controller.showLoginForm( 
		    		new PublicPages.Models.FlashMessage(object)
		    	);
		    	
		    }
		    else{
		    	//update the view to show errors			    	
		    	signUpView.showErrors(data.errors);
		    }
		  })
		  .fail(function() {
		  	//need to handle the connection error
		   console.log("error");
		  })
		  .always(function() {
		   
			});
		},

		signUpWithGoogle: function(userType, signUpView){
			var startTime = moment();
			var firstTime = true;
			while(typeof auth2 == 'undefined' && moment() - startTime < 2000){
				if(firstTime){
					console.log("waiting for gapi to load");
					firstTime = false;
				}
			}

			if(typeof auth2 == 'undefined'){
				var alertModel = new Backbone.Model({
   				message: "There was an error communicating with Google.  Click the sign up button on again, or reload this page and try again.",
   				message_type: "error"
   			});

   			var alertView = new PublicPages.SignUpAndLoginApp.AlertView({model: alertModel});
   			signUpView.flashMessageRegion.show(alertView);


			}
			else{
				auth2.grantOfflineAccess({
					'redirect_uri': 'postmessage',
					'prompt': 'login select_account'
				}).then(function(authResult){
					PublicPages.SignUpAndLoginApp.SignUp.Controller.signInCallback(authResult, userType, signUpView);
				});
			}

		},

		signInCallback: function(authResult, userType, signUpView) {
			
			var postUrl;
			if(userType == "Teacher")
			 postUrl = "/teacher_google_sign_up";
			else if(userType == "Student")
				postUrl = "/student_google_sign_up"

			var postData = "authorization_code=" + authResult.code;

			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made with authorization code');
			})
			.done(function(data) {

				console.log(data);
	     	if(data.status == "success"){
					if(userType == "Teacher")
	     			window.location.replace("teacher_home");
	     		else if (userType == "Student") 
	     			window.location.replace("student_home");;

	     	}
	     	else if(data.status == "error"){

	     		if(data.message == "unable-to-save-user" && data.errors.email){

	     			var alertModel = new Backbone.Model({
	     				message: "An account already exists for the email address associated with this Google account.  Please trying logging in instead.",
	     				message_type: "error"
	     			});
	     			
	     			var alertView = new PublicPages.SignUpAndLoginApp.AlertView({model: alertModel});
	     			signUpView.flashMessageRegion.show(alertView);

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