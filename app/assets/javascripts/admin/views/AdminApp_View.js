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

			flashMessage: function(object){
				var model = new Backbone.Model(object);
				var view = new AdminApp.AlertView({model: model});
				this.alertRegion.show(view);
			},

			



			onChildviewBecomeUser: function(view){
				AdminApp.Controller.becomeUser(view.model, this);
			},

			onChildviewSearchUsers: function(view){
				AdminApp.Controller.searchUsers(view, view.ui.searchForm, this );
			}
			

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

			},

			triggers:{
				"submit @ui.searchForm": "searchUsers"
			}

			
			

	});

	





});