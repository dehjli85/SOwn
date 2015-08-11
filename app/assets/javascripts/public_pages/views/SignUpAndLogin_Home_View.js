//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Home", function(SignUpAndLoginApp, PublicPages, Backbone, Marionette, $, _){
	
	SignUpAndLoginApp.MainView = Marionette.LayoutView.extend({				
			template: JST["public_pages/templates/SignUpAndLogin_Home"],
			className: "container",

			triggers: {
				"click @ui.loginButton" : "home:login",
				"click @ui.teacherSignUpButton" : "home:teacher:sign:up",
				"click @ui.studentSignUpButton" : "home:student:sign:up",
			},

			ui:{
				loginButton: "[ui-login-button]",
				teacherSignUpButton: "[ui-teacher-sign-up-button]",
				studentSignUpButton: "[ui-student-sign-up-button]",
			}
			
	});

});