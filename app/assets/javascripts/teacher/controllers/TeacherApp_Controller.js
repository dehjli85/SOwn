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

			var classroomLayout = TeacherAccount.TeacherApp.Classroom.Controller.showClassroomLayout();

			TeacherAccount.TeacherApp.Classroom.Controller.showClassroomHeader(classroomLayout,classroomId, subapp);

			if (subapp === 'scores'){				

				TeacherAccount.TeacherApp.Classroom.Controller.showClassroomScores(classroomLayout,classroomId);	

			}
			else if (subapp === 'edit_activities'){

				TeacherAccount.TeacherApp.Classroom.Controller.showClassroomEditActivities(classroomLayout,classroomId);	

			}
			else if (subapp === 'edit_scores'){

				TeacherAccount.TeacherApp.Classroom.Controller.showClassroomEditScores(classroomLayout,classroomId);	

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



		}
		

		
	}

});