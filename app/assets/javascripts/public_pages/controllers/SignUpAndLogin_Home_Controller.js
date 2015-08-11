//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Home", function(Home, PublicPages, Backbone, Marionette, $, _){
	
	Home.Controller = {

		showActionButtons: function(){

			console.log("Home Controller: showActionButtons called");
			var mainView = new PublicPages.SignUpAndLoginApp.Home.MainView();

			PublicPages.rootView.mainRegion.show(mainView);		

		}

	}	

});