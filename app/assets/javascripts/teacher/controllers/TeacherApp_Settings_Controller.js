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

			var x = settingsLayoutView;
			var postUrl = "teacher/delete_account"
			var postData = "teacher_user_id=" + userModel.attributes.teacher.id;
			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made to delete teacher account');
			})
			.done(function(data) {

				console.log(data);
				$('.modal-backdrop').remove(); //This is a hack, don't know why the backdrop isn't going away

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

		}
		
	}

});