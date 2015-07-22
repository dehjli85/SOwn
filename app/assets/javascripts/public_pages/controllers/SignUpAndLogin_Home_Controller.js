//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Home", function(Home, PublicPages, Backbone, Marionette, $, _){
	
	Home.Controller = {

		showActionButtons: function(){

			console.log("Home Controller: showActionButtons called");
			var mainView = new PublicPages.SignUpAndLoginApp.Home.MainView();

			

			mainView.on("home:login", function(){				
				PublicPages.SignUpAndLoginApp.Login.Controller.showLoginForm();
			});

			mainView.on("home:teacher-sign-up", function(){
				console.log("teacher sign up trigger heard");
				PublicPages.SignUpAndLoginApp.SignUp.Controller.showTeacherSignUpForm();
			});

			mainView.on("home:student-sign-up", function(){
				console.log("student sign up trigger heard");
				PublicPages.SignUpAndLoginApp.SignUp.Controller.showStudentSignUpForm();
			});


			PublicPages.mainRegion.show(mainView);		

		}

	}	

});