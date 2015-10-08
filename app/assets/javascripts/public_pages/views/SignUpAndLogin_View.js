//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp", function(SignUpAndLoginApp, PublicPages, Backbone, Marionette, $, _){
	
	SignUpAndLoginApp.LayoutView = Marionette.LayoutView.extend({				
			template: JST["public_pages/templates/SignUpAndLogin_Layout"],
			el:"#public_pages_region",
			regions:{
				mainRegion: "#main_region",
				alertRegion: "#alert_region"
			},

			ui:{
				loginButton: "[ui-login-button]",				
				teacherSignUpButton: "[ui-teacher-sign-up-button]",
				studentSignUpButton: "[ui-student-sign-up-button]",
			},

			triggers:{
				"click @ui.loginButton" : "home:login",				
			},

			events:{
				"click @ui.teacherSignUpButton": "onChildviewHomeTeacherSignUp",
				"click @ui.studentSignUpButton": "onChildviewHomeStudentSignUp"
			},


			onHomeLogin: function(){				
				PublicPages.SignUpAndLoginApp.Login.Controller.showLoginForm();
			},

			onChildviewHomeTeacherSignUp:  function(){
				PublicPages.SignUpAndLoginApp.SignUp.Controller.showSignUpForm("Teacher");
			},

			onChildviewHomeStudentSignUp: function(){
				PublicPages.SignUpAndLoginApp.SignUp.Controller.showSignUpForm("Student");
			},

			onChildviewShowTermsOfService:function(view){
				PublicPages.navigate("terms_of_service");
				PublicPages.SignUpAndLoginApp.Home.Controller.showTermsOfService();
			},

			onChildviewShowPrivacyPolicy:function(view){
				PublicPages.SignUpAndLoginApp.Home.Controller.showPrivacyPolicy();
			},

	});

	SignUpAndLoginApp.AlertView = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_Alert"]
	});

	

});