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
			modalDiv: "[ui-modal-div]"
		},

		events:{
			"click @ui.deleteAccountLink": "showVerifyDeleteModal"
		},

		triggers:{
			"click @ui.deleteButton": "delete:teacher:account"
		},

		showVerifyDeleteModal: function(e){
			e.preventDefault();
			this.ui.modalDiv.modal("show");
		},

		onDeleteTeacherAccount: function(view){
			console.log(view);
			TeacherAccount.TeacherApp.Settings.Controller.deleteTeacherAccount(this, view.model);
		}


	});


	

	

});