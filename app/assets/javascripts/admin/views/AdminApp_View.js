//= require public_pages/public_pages

Admin.module("AdminApp", function(AdminApp, Admin, Backbone, Marionette, $, _){
	
	AdminApp.LayoutView = Marionette.LayoutView.extend({				
			template: JST["admin/templates/AdminApp_Layout"],
			el:"#admin_region",
			regions:{
				mainRegion: "#main_region",
				alertRegion: "#alert_region",
				modalRegion: "[ui-modal-div]"
			},

			ui:{
				modalDiv: "[ui-modal-div]"
			},

			onChildviewLogInWithGoogle: function(view){				
				AdminApp.Controller.logInWithGoogle(this);			
			},

			onChildviewUpdatePassword: function(changePasswordModalView){
				AdminApp.Controller.updatePassword(this, changePasswordModalView);
			},

			flashMessage: function(object){
				var model = new Backbone.Model(object);
				var view = new AdminApp.AlertView({model: model});
				this.alertRegion.show(view);
			},

	});

	AdminApp.AlertView = Marionette.ItemView.extend({
		template: JST["admin/templates/AdminApp_Alert"]
	});

	AdminApp.LoginFormView = Marionette.ItemView.extend({				
			template: JST["admin/templates/AdminApp_LoginForm"],
			className: "col-md-6 col-md-offset-3 my-login-form",

			events: {
				"click @ui.googleLogInButton": "logInWithGoogle"
			},

			ui:{
				googleLogInButton: "[ui-google-log-in-button]"

			},

			logInWithGoogle: function(e){
				e.preventDefault();
				if(!this.ui.googleLogInButton.attr("disabled")){
					this.triggerMethod("log:in:with:google");
				}
			},

			onShow: function(){
				var obj = this;
				$('[data-toggle="tooltip"]').tooltip()
				this.checkGoogleApiLoaded(obj);
			},

			checkGoogleApiLoaded: function(loginFormView){

				if(typeof(auth2) == 'undefined'){
					console.log("auth2 undefined");
					setTimeout(function(){loginFormView.checkGoogleApiLoaded(loginFormView)}, 1000);
				}else{
					console.log(loginFormView);
					console.log("auth2 defined");
					loginFormView.ui.googleLogInButton.removeAttr("disabled");
					loginFormView.ui.googleLogInButton.tooltip('destroy');
				}

			}

			
	});

	AdminApp.UserView = Marionette.ItemView.extend({
		template: JST["admin/templates/AdminApp_User"],
		tagName: "tr",

		ui:{
			becomeUserLink: "[ui-become-user-link]",
			userMetricsLink: "[ui-user-metrics-link]",
			changePasswordLink: "[ui-change-password-link]"
		},

		triggers:{
			"click @ui.becomeUserLink" : "become:user",
			"click @ui.userMetricsLink" : "show:user:metrics",
			"click @ui.changePasswordLink" : "open:change:password:modal"
		},

		onOpenChangePasswordModal: function(view){
			Admin.AdminApp.Controller.openChangePasswordModal(this);
		},

	});

	AdminApp.UserIndexCompositeView = Marionette.CompositeView.extend({
			template: JST["admin/templates/AdminApp_UserIndexComposite"],
			className: "row",
			childView: AdminApp.UserView,
			childViewContainer: "tbody",

			ui:{
				searchForm: "[ui-search-form]",
				searchTermInput: "[ui-search-term-input]"
			},

			events:{
				"submit @ui.searchForm": "searchUsers"
			},

			onShow: function(){
				if(this.model.get("searchTerm") != null){
					this.ui.searchTermInput.val(this.model.get("searchTerm"));
					this.triggerMethod("search:users");
				}
			},

			searchUsers: function(e){
				e.preventDefault();
				Admin.navigate("/users_index?searchTerm=" + encodeURI(this.ui.searchTermInput.val()));
				this.triggerMethod("search:users");
			}	

	});

	AdminApp.AdminHomeLayoutView = Marionette.LayoutView.extend({
		template: JST["admin/templates/AdminApp_AdminHomeLayout"],
		className: "",
		regions: {
			sidebarRegion: "#sidebar_region",
			mainAdminHomeRegion: "#main_admin_home_region",
			alertRegion: "#alert_region",
		},

		ui:{
			usersIndexLink: "[ui-users-index-link]",
			metricsLink: "[ui-metrics-link]",
		},

		events:{
			"click @ui.usersIndexLink": "showUsersIndex",
			"click @ui.metricsLink": "showMetrics",
		},

		showUsersIndex: function(){
			AdminApp.Controller.showUsersIndex(this);
		},

		showMetrics: function(){
			AdminApp.Controller.showMetrics(this);
		},

		onChildviewBecomeUser: function(view){
			AdminApp.Controller.becomeUser(view.model, this);
		},

		onChildviewSearchUsers: function(view){
			AdminApp.Controller.searchUsers(view, view.ui.searchForm, this );
		},

		onChildviewShowUserMetrics: function(view){
			AdminApp.Controller.showUserMetrics(this, view.model.attributes.user_type, view.model.attributes.id);
		},

		flashMessage: function(object){
			var model = new Backbone.Model(object);
			var view = new AdminApp.AlertView({model: model});
			this.alertRegion.show(view);
		},

	});


	AdminApp.ChangePasswordModalView = Marionette.ItemView.extend({
		template: JST["admin/templates/AdminApp_ChangePasswordModal"],
		className: "modal-dialog",

		ui:{
			updateButton: "[ui-update-button]",
			newPasswordInput: "[ui-new-password-input]",
			alertDiv: "[ui-alert-div]",
			passwordForm: "[ui-password-form]"
		},

		events:{
			"click @ui.updateButton": "updatePassword",
			"submit @ui.passwordForm": "updatePassword",
		},

		updatePassword: function(e){
			
			e.preventDefault();

			this.ui.alertDiv.removeClass("alert");
			this.ui.alertDiv.removeClass("alert-danger");
			this.ui.alertDiv.html("");

			// verify new password isn't blank 
			if(this.ui.newPasswordInput.val() == null || this.ui.newPasswordInput.val().trim() == ""){
				
				// show an error
				this.ui.alertDiv.addClass("alert alert-danger");
				this.ui.alertDiv.html("Your new password cannot be blank...")

			}else{
				this.triggerMethod("update:password");
			}
		}

	})





});