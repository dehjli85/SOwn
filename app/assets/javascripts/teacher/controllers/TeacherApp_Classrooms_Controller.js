//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classrooms", function(Classrooms, TeacherAccount, Backbone, Marionette, $, _){

	Classrooms.Controller = {

		showClassroomOverviews: function(){
			console.log("preparing classroom overview");
			
			//query for model data
			var jqxhr = $.get("/classrooms_summary", function(){
				console.log('get request made');
			})
			.done(function(data) {

				console.log(data);
	     	
	     	if(data.status == "success"){
	     		
	     		var classroomWidgetRowView = new TeacherAccount.TeacherApp.Classrooms.ClassroomWidgetRowView({collection: new Backbone.Collection(data.classrooms)});					     	
	  	   	TeacherAccount.rootView.mainRegion.show(classroomWidgetRowView);
		
	     	}
	     	else{

	     		//TODO: show an error somewhere on the page

	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		showClassroomNew: function(){
			
			var classroom = new TeacherAccount.TeacherApp.Classrooms.Models.Classroom({
				name: "",
				description: "",
				classroom_code: "",
				errors:{},
				editOrNew: "new"	
			});			

			var classroomView = new TeacherAccount.TeacherApp.Classrooms.ClassroomView({model:classroom});
			TeacherAccount.rootView.mainRegion.show(classroomView);
		},

		saveClassroom: function(classroomView){

			var postUrl;
			if(classroomView.model.attributes.editOrNew == "new"){
				postUrl = "teacher/save_new_classroom";	
			}else if(classroomView.model.attributes.editOrNew == "edit"){
				postUrl = "teacher/update_classroom";
			}
			
			var jqxhr = $.post(postUrl, classroomView.ui.classroomForm.serialize(), function(){
				console.log('post request to save new activity');
			})
			.done(function(data) {

				console.log(data);
				if(data.status == "success"){
					//show a success message, render the edit activity page
					// console.log("success")
					if(classroomView.model.attributes.editOrNew == "new"){
						Classrooms.Controller.showClassroomOverviews();

						var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Activity successfully saved!"});
						var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
						TeacherAccount.navigate("classrooms") //has to be before show, because navigate clears the alerts
						TeacherAccount.rootView.alertRegion.show(alertView);
					}
					else if(classroomView.model.attributes.editOrNew == "edit"){
						var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Activity successfully saved!"});
						var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
						TeacherAccount.rootView.alertRegion.show(alertView);

					}
					
				}
				else{
					//show an error message
					classroomView.showErrors(data.errors);
				}

				
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	
		}

	}

})