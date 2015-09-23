//= require admin/admin
Admin.module("AdminApp", function(AdminApp, Admin, Backbone, Marionette, $, _){
	AdminApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"users_index": "showUsersIndex",
			"metrics": "showMetrics",
			"user_metrics/:userType/:id": "showUserMetrics"
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

		showUserMetrics: function(userType, id){
			Admin.navigate("user_metrics/" + userType + "/" + id);
			this.checkLoggedIn(function(){AdminApp.Controller.startAdminApp("user_metrics", userType, id)});
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
		API.checkLoggedIn(function(){
			Admin.navigate("users_index");
			AdminApp.Controller.startAdminApp("users_index");
		});
	});

	Admin.addInitializer(function(){
		new AdminApp.Router({
			controller: API
		});

		Admin.rootView = new Admin.AdminApp.LayoutView();
		Admin.rootView.render();

	});
});

