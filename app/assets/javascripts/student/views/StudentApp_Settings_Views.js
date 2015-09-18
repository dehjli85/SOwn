//= require student/student

StudentAccount.module("StudentApp.Settings", function(Settings, StudentAccount, Backbone, Marionette, $, _){

	Settings.SettingsLayoutView = Marionette.LayoutView.extend({
		template: JST["student/templates/StudentApp_Settings_SettingsLayout"],			
		className: "col-md-8 col-sm-4",
		regions:{			

		},

		ui: {
			modalDiv: "[ui-modal-div]",
			defaultViewSelect: "[ui-default-view-select]",
			settingsForm: "[ui-settings-form]",
			saveButton: "[ui-save-button]"
		},

		events:{
		},

		triggers:{
			"click @ui.saveButton": "save:settings"
		},

		onSaveSettings: function(view){
			StudentAccount.StudentApp.Settings.Controller.saveSettings(this, this.ui.settingsForm);
		},

		onShow: function(){
        $(".icon-lg").tooltip();

		}


	});


	

	

});