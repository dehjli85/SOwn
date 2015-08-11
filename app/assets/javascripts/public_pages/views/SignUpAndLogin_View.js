//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp", function(SignUpAndLoginApp, PublicPages, Backbone, Marionette, $, _){
	
	SignUpAndLoginApp.LayoutView = Marionette.LayoutView.extend({				
			template: JST["public_pages/templates/SignUpAndLogin_Layout"],
			el:"#public_pages_region",
			regions:{
				mainRegion: "#main_region",
				alertRegion: "#alert_region"
			},

			onChildviewHomeLogin: function(){				
				PublicPages.SignUpAndLoginApp.Login.Controller.showLoginForm();
			},

			onChildviewHomeTeacherSignUp:  function(){
				PublicPages.SignUpAndLoginApp.SignUp.Controller.showSignUpForm("Teacher");
			},

			onChildviewHomeStudentSignUp: function(){
				PublicPages.SignUpAndLoginApp.SignUp.Controller.showSignUpForm("Student");
			}

	});

	SignUpAndLoginApp.AlertView = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_Alert"]
	});

});