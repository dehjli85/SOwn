//= require admin/admin
Admin.module("AdminApp", function(AdminApp, Admin, Backbone, Marionette, $, _){
	AdminApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"users_index": "showUsersIndex",
			"metrics": "showMetrics"	
		}		
	});

	var API = {
		showLoginButton: function(){
			AdminApp.Controller.showLoginButton();			
		},

		showUsersIndex: function(){

			//check if session is valid
			Admin.navigate("users_index");
			this.checkLoggedIn(function(){AdminApp.Controller.startAdminApp("users_index")});
			
		},

		showMetrics: function(){

			//check if session is valid
			Admin.navigate("metrics");
			this.checkLoggedIn(function(){AdminApp.Controller.startAdminApp("metrics")});
			
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
		API.checkLoggedIn(AdminApp.Controller.showUsersIndex);
	});

	Admin.addInitializer(function(){
		new AdminApp.Router({
			controller: API
		});

		Admin.rootView = new Admin.AdminApp.LayoutView();
		Admin.rootView.render();

	});
});

