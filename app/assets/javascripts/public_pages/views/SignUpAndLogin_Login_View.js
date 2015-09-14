//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Login", function(LoginApp, PublicPages, Backbone, Marionette, $, _){
	
	LoginApp.Layout = Marionette.LayoutView.extend({				
			template: JST["public_pages/templates/SignUpAndLogin_Login_Layout"],
			className: "container-fluid container-fluid_no-padding",

			regions:{
				loginFormRegion: "#login-form-region",
				flashMessageRegion: "#flash-message-region"
			},

			flashErrorMessage: function(errorObject){
				var errorModel = new PublicPages.Models.FlashMessage(errorObject);
				var errorView = new LoginApp.FlashMessageRegion({model: errorModel});
				this.flashMessageRegion.show(errorView);
			},

			flashSuccessMessage: function(successObject){
				var successModel = new PublicPages.Models.FlashMessage(successObject);
				var successView = new LoginApp.FlashMessageRegion({model: successModel});
				this.flashMessageRegion.show(successView);
			},

			clearMessages: function(){
				this.flashMessageRegion.empty();
			},

			onChildviewLoginSignIn: function(view){
				PublicPages.SignUpAndLoginApp.Login.Controller.postLogin(view, this);
			},		

			onChildviewLogInWithGoogle: function(view){				
				LoginApp.Controller.logInWithGoogle(this);			
			},			

			onChildviewTeacherSignUp: function(view){
				PublicPages.SignUpAndLoginApp.SignUp.Controller.showSignUpForm("Teacher");
			},

			onChildviewStudentSignUp: function(view){
				PublicPages.SignUpAndLoginApp.SignUp.Controller.showSignUpForm("Student");
			}
				
			
	});

	LoginApp.FlashMessageRegion = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_Login_FlashMessageRegion"]
	});

	LoginApp.LoginFormRegion = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_Login_LoginFormRegion"],

		
		triggers:{
			"click button.js-sign-in": "login:sign:in",
			"click @ui.googleLogInButton": "log:in:with:google",
			"click @ui.teacherSignUpLink": "teacher:sign:up",
			"click @ui.studentSignUpLink": "student:sign:up",
		},

		events:{
			"click @ui.signInAccountButton": "revealLoginForm",
			"click @ui.googleLogInButton": "logInWithGoogle",
		},

		ui:{
			credentialsForm: '[ui-credentials-form]',
			signInAccountButton: '[ui-sign-in-account-button]',
			standardFormDiv: "[ui-standard-form-div]",
			googleLogInButton: "[ui-google-log-in-button]",
			teacherSignUpLink: "[ui-teacher-sign-up-link]",
			studentSignUpLink: "[ui-student-sign-up-link]"
		},

		revealLoginForm: function(){
			this.ui.standardFormDiv.attr("style", "display:block");			
			this.ui.signInAccountButton.attr("style", "display:none");
		},

		logInWithGoogle: function(e){
			e.preventDefault();
		}

		
	})

});