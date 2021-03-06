//= require teacher/teacher

TeacherAccount.module("TeacherApp.Settings", function(Settings, TeacherAccount, Backbone, Marionette, $, _){

	Settings.SettingsLayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Settings_SettingsLayout"],			
		className: "col-md-8 col-sm-4",
		regions:{			
			modalRegion: "[ui-modal-div]"
		},

		ui: {
			deleteAccountLink: "[ui-delete-account-link]",
			deleteButton: "[ui-delete-button]",
			modalDiv: "[ui-modal-div]",
			defaultViewSelect: "[ui-default-view-select]",
			settingsForm: "[ui-settings-form]",
			saveButton: "[ui-save-button]",
			convertStgLink: "[ui-convert-stg-link]",
			changePasswordLink: "[ui-change-password-link]"
		},

		events:{
			"click @ui.deleteAccountLink": "showVerifyDeleteModal"
		},

		triggers:{
			"click @ui.deleteButton": "delete:teacher:account",
			"click @ui.saveButton": "save:settings",
			"click @ui.changePasswordLink": "open:change:password:modal",
			"click @ui.convertStgLink": "open:convert:modal"
		},

		showVerifyDeleteModal: function(e){
			e.preventDefault();
			this.ui.modalDiv.modal("show");
		},

		onDeleteTeacherAccount: function(view){
			TeacherAccount.TeacherApp.Settings.Controller.deleteTeacherAccount(this, view.model);
		},

		onSaveSettings: function(view){
			TeacherAccount.TeacherApp.Settings.Controller.saveSettings(this, this.ui.settingsForm);
		},

		onOpenChangePasswordModal: function(view){
			console.log(this.modalRegion);
			TeacherAccount.TeacherApp.Settings.Controller.openChangePasswordModal(this);
		},

		onOpenConvertModal: function(view){
			TeacherAccount.TeacherApp.Settings.Controller.openConvertModal(this);
		},

		onChildviewUpdatePassword: function(changePasswordModalView){
			TeacherAccount.TeacherApp.Settings.Controller.updatePassword(this, changePasswordModalView);
		},

		onChildviewConvertAccount: function(convertModalView){
			TeacherAccount.TeacherApp.Settings.Controller.convertAccount(this, convertModalView);
		}


	});

	Settings.ChangePasswordModalView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Settings_ChangePasswordModal"],
		className: "modal-dialog",

		ui:{
			updateButton: "[ui-update-button]",
			oldPasswordInput: "[ui-old-password-input]",
			newPasswordInput: "[ui-new-password-input]",
			confirmPasswordInput: "[ui-confirm-password-input]",
			alertDiv: "[ui-alert-div]",
			passwordForm: "[ui-password-form]"
		},

		events:{
			"click @ui.updateButton": "updatePassword"
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

			// verify new and confirm are same 
			}else if(this.ui.newPasswordInput.val() != this.ui.confirmPasswordInput.val()){

				// show an error
				this.ui.alertDiv.addClass("alert alert-danger");
				this.ui.alertDiv.html("New Password and Confirm New Password do not match...")

			}else if(this.ui.oldPasswordInput.val() == null || this.ui.oldPasswordInput.val().trim() == ""){
				
				// show an error
				this.ui.alertDiv.addClass("alert alert-danger");
				this.ui.alertDiv.html("You must submit your old password...")

			}else{
				this.triggerMethod("update:password");
			}
		}

	});
	
	Settings.ConvertModalView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Settings_ConvertModal"],
		className: "modal-dialog",

		ui:{
			convertButton: "[ui-convert-button]",
			passwordInput: "[ui-password-input]",
			confirmPasswordInput: "[ui-confirm-password-input]",
			alertDiv: "[ui-alert-div]",
			passwordForm: "[ui-password-form]",
			googleLogInButton: "[ui-google-log-in-button]"
		},

		events:{
			"click @ui.convertButton": "convertAccount",
			"click @ui.googleLogInButton": "convertAccount"
		},

		convertAccount: function(e){
			
			// If this is a google user converting to non-google account, 
			// do a bunch of validation before triggering the convert controller action
			if(this.model.get("teacher").provider != null){
				e.preventDefault();

				this.ui.alertDiv.removeClass("alert");
				this.ui.alertDiv.removeClass("alert-danger");
				this.ui.alertDiv.html("");

				// verify new password isn't blank 
				if(this.ui.passwordInput.val() == null || this.ui.passwordInput.val().trim() == ""){
					
					// show an error
					this.ui.alertDiv.addClass("alert alert-danger");
					this.ui.alertDiv.html("Your new password cannot be blank...")

				// verify new and confirm are same 
				}else if(this.ui.passwordInput.val() != this.ui.confirmPasswordInput.val()){

					// show an error
					this.ui.alertDiv.addClass("alert alert-danger");
					this.ui.alertDiv.html("New Password and Confirm New Password do not match...")

				}else{
					this.triggerMethod("convert:account");
				}
			}
			// If this is a non-google user converting to google account
			else{

				this.triggerMethod("convert:account");
			
			}

		}

	});
	

	

});