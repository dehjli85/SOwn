//= require student/student

StudentAccount.module("StudentApp.Settings", function(Settings, StudentAccount, Backbone, Marionette, $, _){

	Settings.SettingsLayoutView = Marionette.LayoutView.extend({
		template: JST["student/templates/StudentApp_Settings_SettingsLayout"],			
		className: "col-md-8 col-sm-4",
		regions:{			
			modalRegion: "[ui-modal-div]"
		},

		ui: {
			modalDiv: "[ui-modal-div]",
			defaultViewSelect: "[ui-default-view-select]",
			settingsForm: "[ui-settings-form]",
			saveButton: "[ui-save-button]",
			changePasswordLink: "[ui-change-password-link]"
		},

		events:{
		},

		triggers:{
			"click @ui.saveButton": "save:settings",
			"click @ui.changePasswordLink": "open:change:password:modal"
		},

		onSaveSettings: function(view){
			StudentAccount.StudentApp.Settings.Controller.saveSettings(this, this.ui.settingsForm);
		},

		onShow: function(){
        $(".icon-lg").tooltip();
		},

		onOpenChangePasswordModal: function(view){
			console.log(this.modalRegion);
			StudentAccount.StudentApp.Settings.Controller.openChangePasswordModal(this);
		},

		onChildviewUpdatePassword: function(changePasswordModalView){
			StudentAccount.StudentApp.Settings.Controller.updatePassword(this, changePasswordModalView);
		}


	});

	Settings.ChangePasswordModalView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Settings_ChangePasswordModal"],
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

	})


	

	

});