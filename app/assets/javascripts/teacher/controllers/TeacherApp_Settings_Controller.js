//= require teacher/teacher

TeacherAccount.module("TeacherApp.Settings", function(Settings, TeacherAccount, Backbone, Marionette, $, _){

	Settings.Controller = {

		showSettingsOptions: function(){

			//get user model data and create the header
			var jqxhr = $.get("/current_user", function(){
				console.log('get request made for teacher user data');
			})
			.done(function(data) {
					     	
	     	//fetch user model and create header
	     	var user = new Backbone.Model({teacher: data.teacher, student: data.student});
				var settingsLayoutView = new TeacherAccount.TeacherApp.Settings.SettingsLayoutView({model:user});

				TeacherAccount.rootView.mainRegion.show(settingsLayoutView);


		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		deleteTeacherAccount: function(settingsLayoutView, userModel){

			var postUrl = "teacher/delete_account"
			var postData = "teacher_user_id=" + userModel.attributes.teacher.id;
			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made to delete teacher account');
			})
			.done(function(data) {

				console.log(data);
				$('.modal-backdrop').remove(); //This is a hack, don't know why the backdrop isn't going away
     		$('body').removeClass('modal-open'); //This is a hack, don't know why the backdrop isn't going away
				

				if(data.status == "success"){

					var alertModel = new Backbone.Model({message: "Your account has been deleted.  You will be redirected in a moment...", alertClass: "alert-danger"})
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});

					TeacherAccount.rootView.alertRegion.show(alertView);

					setTimeout(function(){
						window.location.replace("/");
					}, 5000);
				}
				else if(data.status == "error"){

					var alertModel = new Backbone.Model({message: "Unable to delete account.  Please email help@sowntogrow.com to delete your account.", alertClass: "alert-danger"})
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});

					TeacherAccount.rootView.alertRegion.show(alertView);

				}
	     	
	     	//fetch user model and create header
	     	var user = new Backbone.Model({teacher: data.teacher, student: data.student});
				var settingsLayoutView = new TeacherAccount.TeacherApp.Settings.SettingsLayoutView({model:user});

				TeacherAccount.rootView.mainRegion.show(settingsLayoutView);


		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		saveSettings: function(settingsLayoutView, settingsForm){

			var postUrl = "teacher/save_settings"
			var postData = settingsForm.serialize();
			console.log(postData);
			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made to save settings');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					TeacherAccount.TeacherApp.Settings.Controller.showSettingsOptions();

					var alertModel = new Backbone.Model({message: "Settings Saved.", alertClass: "alert-success"})
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});

					TeacherAccount.rootView.alertRegion.show(alertView);

				}
				else if(data.status == "error"){

					var alertModel = new Backbone.Model({message: "Unable to save settings.  Please try again later.", alertClass: "alert-danger"})
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});

					TeacherAccount.rootView.alertRegion.show(alertView);

				}
	     	
	     	

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		openChangePasswordModal: function(settingsLayoutView){

			var changePasswordModalView = new TeacherAccount.TeacherApp.Settings.ChangePasswordModalView();
			settingsLayoutView.modalRegion.show(changePasswordModalView);

			settingsLayoutView.ui.modalDiv.modal("show");
		},

		updatePassword: function(settingsLayoutView, changePasswordModalView){

			var postUrl = "teacher/update_password"
			var postData = changePasswordModalView.ui.passwordForm.serialize();

			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made to save student settings');
			})
			.done(function(data) {

				console.log(data);

				if(data.status == "success"){

					settingsLayoutView.ui.modalDiv.modal("hide");
					
					var alertModel = new Backbone.Model({message: "Password has been saved.", alertClass: "alert-success"})
					var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});

					TeacherAccount.rootView.alertRegion.show(alertView);					

				}
				else if(data.status == "error"){

					if(data.message == "incorrect-original-password-for-specified-user"){
						changePasswordModalView.ui.alertDiv.html("Incorrect old password...")

					}else{
						changePasswordModalView.ui.alertDiv.html("Error saving password...")
					}

					changePasswordModalView.ui.alertDiv.addClass("alert alert-danger");

				}
	     	
	     	

		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		openConvertModal: function(settingsLayoutView){
			var convertModalView = new TeacherAccount.TeacherApp.Settings.ConvertModalView({model: settingsLayoutView.model});
			settingsLayoutView.modalRegion.show(convertModalView);

			settingsLayoutView.ui.modalDiv.modal("show");
		},

		convertAccount: function(settingsLayoutView, convertModalView){

			// if the user is a Google user trying to convert to STG user
			if(convertModalView.model.get("teacher").provider != null){

				var postUrl = "teacher/convert_account"
				var postData = convertModalView.ui.passwordForm.serialize();

				var jqxhr = $.post(postUrl, postData, function(){
					console.log('post request made to save student settings');
				})
				.done(function(data) {

					console.log(data);

					if(data.status == "success"){

						settingsLayoutView.ui.modalDiv.modal("hide");
						$('.modal-backdrop').remove(); //This is a hack, don't know why the backdrop isn't going away
	     			$('body').removeClass('modal-open'); //This is a hack, don't know why the backdrop isn't going away
						
						var alertModel = new Backbone.Model({message: "Your account has been converted.", alertClass: "alert-success"})
						var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});

						TeacherAccount.rootView.alertRegion.show(alertView);					

						Settings.Controller.showSettingsOptions();

					}
					else if(data.status == "error"){

						changePasswordModalView.ui.alertDiv.addClass("alert alert-danger");
						changePasswordModalView.ui.alertDiv.html("Error converting account...");

					}
		     	
		     	

			  })
			  .fail(function() {
			  	console.log("error");
			  })
			  .always(function() {
			   
				});
			}

			// if the user is a STG user trying to convert to a Google User
			else{
				
				// Sign the user out
				auth2.signOut()

				// Make them sign in and get an authorization code to send to the server

				auth2.grantOfflineAccess({'redirect_uri': 'postmessage'}).then(function(authResult){
				
					var postUrl = "/teacher/convert_account"
					var postData = "authorization_code=" + authResult.code;

					var jqxhr = $.post(postUrl, postData, function(){
						console.log('post request made with authorization code');
					})
					.done(function(data) {

						if (data.status === 'success'){

							var alertModel = new Backbone.Model({message: "Your account has been converted.", alertClass: "alert-success"})
							var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});

							TeacherAccount.rootView.alertRegion.show(alertView);	

							// reload the entire settings page
							$('.modal-backdrop').remove(); //This is a hack, don't know why the backdrop isn't going away
		     			$('body').removeClass('modal-open'); //This is a hack, don't know why the backdrop isn't going away
							Settings.Controller.showSettingsOptions();
							

				    }
				    else{
				    	
				    	// show an error message in the modal
				    	convertModalView.ui.alertDiv.addClass("alert alert-danger");
							convertModalView.ui.alertDiv.html("Error converting account...");
				    }
			     	
			     	
				  })
				  .fail(function() {
				  	console.log("error");
				  })
				  .always(function() {
				   
					});
		
				
				});



			}

		}

		
	}

});