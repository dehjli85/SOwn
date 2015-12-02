//= require admin/admin
Admin.module("AdminApp", function(AdminApp, Admin, Backbone, Marionette, $, _){
	AdminApp.Router = Marionette.AppRouter.extend({
		appRoutes:{
			"users_index": "showUsersIndex",
			"users_index?query": "showUsersIndex",
			"metrics": "showMetrics",
			"user_metrics/:userType/:id": "showUserMetrics",
			"upload_roster": "showUploadRoster"
		}		
	});

	var API = {
		showLoginButton: function(){
			AdminApp.Controller.showLoginButton();			
		},

		showUsersIndex: function(query){

			var searchTerm = query ? query.replace("searchTerm=","") : null; 

			this.checkLoggedIn(function(){AdminApp.Controller.startAdminApp("users_index", searchTerm)});
			
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

		showUploadRoster: function(){

			this.checkLoggedIn(function(){AdminApp.Controller.startAdminApp("upload_roster")});

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

