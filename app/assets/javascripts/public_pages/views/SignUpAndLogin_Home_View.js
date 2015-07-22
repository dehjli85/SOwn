//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Home", function(SignUpAndLoginApp, PublicPages, Backbone, Marionette, $, _){
	
	SignUpAndLoginApp.MainView = Marionette.LayoutView.extend({				
			template: JST["public_pages/templates/SignUpAndLogin_Home"],
			className: "container",

			events: {
				"click a.js-login": "login",
				"click a.js-teacher-sign-up": "teacherSignUp",
				"click a.js-student-sign-up": "studentSignUp"
			},

			login: function(e){				
				this.trigger("home:login");				
			},

			teacherSignUp: function(e){
				console.log("teacher sign up clicked, trying to trigger...")
				this.trigger("home:teacher-sign-up");
			},

			studentSignUp: function(e){
				this.trigger("home:student-sign-up");
			}
	});

});