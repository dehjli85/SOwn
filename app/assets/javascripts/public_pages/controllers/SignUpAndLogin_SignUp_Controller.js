//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.SignUp", function(SignUp, PublicPages, Backbone, Marionette, $, _){
	
	SignUp.Controller = {
		showTeacherSignUpForm: function(){			

			var signUpView = new PublicPages.SignUpAndLoginApp.SignUp.TeacherSignUpView();

			signUpView.on("sign-up:sign-up", function(args){

				args.view.clearErrors();

				var jqxhr = $.post( "/teacher_users", args.view.ui.signUpForm.serialize(), function() {
				  console.log("post_made");
				})
			  .done(function(data) {
		    	// console.log("successful response");
		     	console.log(data);
			    if (data.status === 'success'){			    	
		    		//redirect to login page
			    	PublicPages.SignUpAndLoginApp.Login.Controller.showLoginForm( new PublicPages.Models.FlashMessage({message_type: "success", success: "teacher-account-created", message: "Account successfully created.  Please Login."}));
			    	
			    }
			    else{
			    	//update the view to show errors			    	
			    	args.view.showErrors(data.errors);
			    }
			  })
			  .fail(function() {
			  	//need to handle the connection error
			   console.log("error");
			  })
			  .always(function() {
			   
				});
				console.log();
			})

			 PublicPages.mainRegion.show(signUpView);
		}, 

		showStudentSignUpForm: function(){			

			var signUpView = new PublicPages.SignUpAndLoginApp.SignUp.StudentSignUpView();

			signUpView.on("sign-up:sign-up", function(args){

				args.view.clearErrors();

				var jqxhr = $.post( "/student_users", args.view.ui.signUpForm.serialize(), function() {
				  console.log("post_made");
				})
			  .done(function(data) {
		    	// console.log("successful response");
		     	console.log(data);
			    if (data.status === 'success'){			    	
		    		//redirect to login page
			    	PublicPages.SignUpAndLoginApp.Login.Controller.showLoginForm( new PublicPages.Models.FlashMessage({message_type: "success", success: "teacher-account-created", message: "Account successfully created.  Please Login."}));
			    	
			    }
			    else{
			    	//update the view to show errors			    	
			    	args.view.showErrors(data.errors);
			    }
			  })
			  .fail(function() {
			  	//need to handle the connection error
			   console.log("error");
			  })
			  .always(function() {
			   
				});
				console.log();
			})

			 PublicPages.mainRegion.show(signUpView);
		}		

	}

});