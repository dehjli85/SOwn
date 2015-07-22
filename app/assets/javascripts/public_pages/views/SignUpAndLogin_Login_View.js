//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Login", function(LoginApp, PublicPages, Backbone, Marionette, $, _){
	
	LoginApp.Layout = Marionette.LayoutView.extend({				
			template: JST["public_pages/templates/SignUpAndLogin_Layout"],
			className: "container",

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
			}			
				
			
	});

	LoginApp.FlashMessageRegion = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_Login_FlashMessageRegion"]
	});

	LoginApp.LoginFormRegion = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_Login_LoginFormRegion"],

		
		triggers:{
			"click button.js-sign-in": "login:sign-in"
		},

		ui:{
			credentialsForm: '[credentials-form]'
		}

		
	})

});