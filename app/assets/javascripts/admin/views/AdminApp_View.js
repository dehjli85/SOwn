//= require public_pages/public_pages

Admin.module("AdminApp", function(AdminApp, Admin, Backbone, Marionette, $, _){
	
	AdminApp.LayoutView = Marionette.LayoutView.extend({				
			template: JST["admin/templates/AdminApp_Layout"],
			el:"#admin_region",
			regions:{
				mainRegion: "#main_region",
				alertRegion: "#alert_region"
			},

			onChildviewLogInWithGoogle: function(view){				
				AdminApp.Controller.logInWithGoogle(this);			
			},

			flashErrorMessage: function(errorObject){
				var errorModel = new Backbone.Model(errorObject);
				var errorView = new AdminApp.AlertView({model: errorModel});
				this.alertRegion.show(errorView);
			},
			

	});

	AdminApp.AlertView = Marionette.ItemView.extend({
		template: JST["admin/templates/AdminApp_Alert"]
	});

	AdminApp.MainView = Marionette.LayoutView.extend({				
			template: JST["admin/templates/AdminApp_Main"],
			className: "container",

			triggers: {
				"click @ui.googleLogInButton": "log:in:with:google"

			},

			ui:{
				googleLogInButton: "[ui-google-log-in-button]"

			}
			
	});

	AdminApp.UserView = Marionette.ItemView.extend({
		template: JST["admin/templates/AdminApp_User"],
		tagName: "tr",

		ui:{
			becomeUserLink: "[ui-become-user-link]"
		},

		triggers:{
			"click @ui.becomeUserLink" : "become:user"
		}

	});

	AdminApp.UserIndexCompositeView = Marionette.CompositeView.extend({
			template: JST["admin/templates/AdminApp_UserIndexComposite"],
			className: "col-md-8 col-md-offset-2",
			childView: AdminApp.UserView,
			childViewContainer: "tbody",

			ui:{
				searchForm: "[ui-search-form]"
			},

			events:{
				"submit @ui.searchForm": "searchUsers"
			},

			searchUsers: function(e){
				e.preventDefault();
				AdminApp.Controller.searchUsers(this, this.ui.searchForm );
			},

			onChildviewBecomeUser: function(view){
				AdminApp.Controller.becomeUser(view.model);
			}
			

	});

	





});