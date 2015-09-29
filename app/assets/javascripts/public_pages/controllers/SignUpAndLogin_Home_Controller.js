//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Home", function(Home, PublicPages, Backbone, Marionette, $, _){
	
	Home.Controller = {

		showActionButtons: function(){

			console.log("Home Controller: showActionButtons called");
			var mainView = new PublicPages.SignUpAndLoginApp.Home.MainView();

			PublicPages.rootView.mainRegion.show(mainView);		

		},

		showTermsOfService: function(){
			var termsOfServiceView = new PublicPages.SignUpAndLoginApp.Home.TermsOfServiceView();
			PublicPages.rootView.mainRegion.show(termsOfServiceView);
		},

		showPrivacyPolicy: function(){
			var privacyView = new PublicPages.SignUpAndLoginApp.Home.PrivacyPolicyView();
			PublicPages.rootView.mainRegion.show(privacyView);
		}

	}	

});