//= require teacher/teacher

TeacherAccount.module("TeacherApp.Settings", function(Settings, TeacherAccount, Backbone, Marionette, $, _){

	Settings.SettingsLayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Settings_SettingsLayout"],			
		className: "col-md-8 col-sm-4",
		regions:{			

		},

		ui: {
			deleteAccountLink: "[ui-delete-account-link]",
			deleteButton: "[ui-delete-button]",
			modalDiv: "[ui-modal-div]",
			defaultViewSelect: "[ui-default-view-select]",
			settingsForm: "[ui-settings-form]",
			saveButton: "[ui-save-button]"
		},

		events:{
			"click @ui.deleteAccountLink": "showVerifyDeleteModal"
		},

		triggers:{
			"click @ui.deleteButton": "delete:teacher:account",
			"click @ui.saveButton": "save:settings"
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
		}


	});


	

	

});