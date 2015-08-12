//= require teacher/teacher

TeacherAccount.module("TeacherApp.Main", function(Main, TeacherAccount, Backbone, Marionette, $, _){

	Main.Controller = {

		showHeaderAndLeftNavViews: function(){

			//get user model data and create the header
			var jqxhr = $.get("/current_teacher_user", function(){
				console.log('get request made for teacher user data');
			})
			.done(function(data) {
	     	
	     	//fetch user model and create header
	     	var user = new TeacherAccount.Models.TeacherUser(data.teacher);
				var headerView = new TeacherAccount.TeacherApp.HeaderView({model:user});				
				TeacherAccount.rootView.headerRegion.show(headerView);

				// create the left nav
				var leftNav = new TeacherAccount.TeacherApp.LeftNavView();
				TeacherAccount.rootView.leftNavRegion.show(leftNav);
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		startClassroomApp: function(classroomId, subapp){

			//THIS LINE IS NECESSARY BECAUSE THE D3 WIDGET IS BREAKING NORMAL <A> HREF BEHAVIOR
			//DO NOT DELETE
			TeacherAccount.navigate('classroom/' + subapp + '/' + classroomId);

			var classroomLayoutView = TeacherAccount.TeacherApp.Classroom.Controller.showClassroomLayout(classroomId);
			console.log(classroomLayoutView);

			TeacherAccount.TeacherApp.Classroom.Controller.showClassroomHeader(classroomLayoutView,classroomId, subapp);

			if (subapp === 'scores'){				

				TeacherAccount.TeacherApp.Classroom.Controller.startScoresApp(classroomLayoutView,"read");	

			}
			else if (subapp === 'edit_activities'){

				TeacherAccount.TeacherApp.Classroom.Controller.showClassroomEditActivities(classroomLayoutView,classroomId);	

			}
			else if (subapp === 'edit_scores'){

				TeacherAccount.TeacherApp.Classroom.Controller.startScoresApp(classroomLayoutView,"edit");	

			}
			else if(subapp === 'edit_classroom'){

				TeacherAccount.TeacherApp.Classroom.Controller.showEditClassroom(classroomLayoutView,classroomId);	
					
			}
			
		},

		startActivitiesApp: function(subapp, id){
			url = 'activities';
			if(id){
				url += "/" + id;
			}
			url += "/" + subapp;

			TeacherAccount.navigate(url);
			
			if( subapp === 'index'){
				TeacherAccount.TeacherApp.Activities.Controller.showActivitiesIndex();
			}
			else if(subapp === 'new'){
				TeacherAccount.TeacherApp.Activities.Controller.showNewActivity();
			}
			else if(subapp === 'edit'){
				TeacherAccount.TeacherApp.Activities.Controller.showEditActivity(id);	
			}

		},

		showClassroomNew: function(){
			
			var classroom = new TeacherAccount.Models.Classroom({
				name: "",
				description: "",
				classroom_code: "",
				errors:{},
				editOrNew: "new"	
			});			

			var classroomView = new TeacherAccount.TeacherApp.ClassroomView({model:classroom});
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
						TeacherAccount.TeacherApp.Classrooms.Controller.showClassroomOverviews();

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

});