//= require public_pages/public_pages
PublicPages.module("SignUpAndLoginApp", function(SignUpAndLoginApp, PublicPages, Backbone, Marionette, $, _){
	SignUpAndLoginApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"login": "showLoginForm",
			"login/:loggedOut": "showLoginForm",
			"home": "showActionButtons",
			"sign_up_teacher": "showTeacherSignUpForm",
			"sign_up_student": "showStudentSignUpForm",
			"privacy": "showPrivacy",
			"terms_of_service": "showTermsOfService"
		}		
	});

	var API = {
		showActionButtons: function(){
			console.log("route to home was triggered, showActionButtons");
			SignUpAndLoginApp.Home.Controller.showActionButtons();			
			
		},

		showLoginForm: function(loggedOut){
			if(loggedOut == null){
				SignUpAndLoginApp.Login.Controller.showLoginForm();
			}else{
				var model = new Backbone.Model({message_type: "error", message: "You were logged out because you logged out of Google"})
				SignUpAndLoginApp.Login.Controller.showLoginForm(model);
			}
			console.log("route to login was triggered");
		},

		showTeacherSignUpForm: function(){
			SignUpAndLoginApp.SignUp.Controller.showSignUpForm("Teacher");
			console.log("route to teacher signup was triggered");
		},

		showStudentSignUpForm: function(){
			SignUpAndLoginApp.SignUp.Controller.showSignUpForm("Student");
			console.log("route to student signup was triggered");
		},

		showTermsOfService: function(){
			console.log("route to terms of service was triggered");
			SignUpAndLoginApp.Home.Controller.showTermsOfService();
		},

		showPrivacy: function(){
			SignUpAndLoginApp.Home.Controller.showPrivacyPolicy();
			console.log("route to privacy was triggered");
		}
	};

	PublicPages.on("index:home",function(){
		PublicPages.navigate("home");
		API.showActionButtons();
	});

	PublicPages.addInitializer(function(){
		new SignUpAndLoginApp.Router({
			controller: API
		});

		PublicPages.rootView = new PublicPages.SignUpAndLoginApp.LayoutView();
		PublicPages.rootView.render();

	});
});

