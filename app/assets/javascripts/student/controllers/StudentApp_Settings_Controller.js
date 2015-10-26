//= require student/student

StudentAccount.module("StudentApp.Settings", function(Settings, StudentAccount, Backbone, Marionette, $, _){

	Settings.Controller = {

		showSettingsOptions: function(){

			//get user model data and create the header
			var jqxhr = $.get("/current_user", function(){
				console.log('get request made for teacher user data');
			})
			.done(function(data) {

				console.log(data);
	     	
	     	//fetch user model and create header
	     	var user = new Backbone.Model({teacher: data.teacher, student: data.student});
				var settingsLayoutView = new StudentAccount.StudentApp.Settings.SettingsLayoutView({model:user});

				StudentAccount.rootView.mainRegion.show(settingsLayoutView);


		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		saveSettings: function(settingsLayoutView, settingsForm){

			var postUrl = "student/save_settings"
			var postData = settingsForm.serialize();

			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made to save student settings');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					StudentAccount.StudentApp.Settings.Controller.showSettingsOptions();

					var alertModel = new Backbone.Model({message: "Settings Saved.", alertClass: "alert-success"})
					var alertView = new StudentAccount.StudentApp.AlertView({model: alertModel});

					StudentAccount.rootView.alertRegion.show(alertView);

				}
				else if(data.status == "error"){

					var alertModel = new Backbone.Model({message: "Unable to save settings.  Please try again later.", alertClass: "alert-danger"})
					var alertView = new StudentAccount.StudentApp.AlertView({model: alertModel});

					StudentAccount.rootView.alertRegion.show(alertView);

				}
	     	
	     	

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		openChangePasswordModal: function(settingsLayoutView){

			var changePasswordModalView = new StudentAccount.StudentApp.Settings.ChangePasswordModalView();
			settingsLayoutView.modalRegion.show(changePasswordModalView);

			settingsLayoutView.ui.modalDiv.modal("show");
		},

		updatePassword: function(settingsLayoutView, changePasswordModalView){

			var postUrl = "student/update_password"
			var postData = changePasswordModalView.ui.passwordForm.serialize();

			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made to save student settings');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					settingsLayoutView.ui.modalDiv.modal("hide");
					
					var alertModel = new Backbone.Model({message: "Password has been saved.", alertClass: "alert-success"})
					var alertView = new StudentAccount.StudentApp.AlertView({model: alertModel});

					StudentAccount.rootView.alertRegion.show(alertView);					

				}
				else if(data.status == "error"){

					changePasswordModalView.ui.alertDiv.addClass("alert alert-danger");
					changePasswordModalView.ui.alertDiv.html("Error saving password...")

				}
	     	
	     	

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		}
		
	}

});