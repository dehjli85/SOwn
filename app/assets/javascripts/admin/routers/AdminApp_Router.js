//= require admin/admin
Admin.module("AdminApp", function(AdminApp, Admin, Backbone, Marionette, $, _){
	AdminApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"home": "showLoginButton",
			"users_index": "showUsersIndex"			
		}		
	});

	var API = {
		showLoginButton: function(){
			AdminApp.Controller.showLoginButton();			
		},

		showUsersIndex: function(){

			//check if session is valid
			this.checkLoggedIn(AdminApp.Controller.showUsersIndex)

			
		},

		checkLoggedIn: function(handler){

			var getUrl = "/admin/logged_in"			

			var jqxhr = $.get(getUrl, function(){

			})
			.done(function(data) {

				if (data.status === 'success'){		    	

					handler();

		    }
		    else{
		    	
		    	AdminApp.Controller.showLoginButton();
		    	
		    }
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		}
		
	};

	Admin.on("index:home",function(){
		Admin.navigate("home");
		API.showLoginButton();
	});

	Admin.addInitializer(function(){
		new AdminApp.Router({
			controller: API
		});

		Admin.rootView = new Admin.AdminApp.LayoutView();
		Admin.rootView.render();

	});
});

