//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom", function(Classroom, TeacherAccount, Backbone, Marionette, $, _){

	Classroom.Controller = {

		showClassroomLayout: function(classroomId){


			var classroomLayoutView = new TeacherAccount.TeacherApp.Classroom.LayoutView();			
			classroomLayoutView.model = new Backbone.Model({classroomId:classroomId})

			TeacherAccount.rootView.mainRegion.show(classroomLayoutView);

			return classroomLayoutView;
		},

		showClassroomHeader: function(classroomLayoutView, classroomId, subapp){

			var jqxhr = $.get("/teacher/classroom?classroom_id=" + classroomId, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {

				
	     	
	     	if(data.status == "success"){
	     		
	     		data.classroom.subapp = subapp;

					var classroomModel = new TeacherAccount.TeacherApp.Classroom.Models.Classroom(data.classroom);
					
		     	var headerView = new TeacherAccount.TeacherApp.Classroom.HeaderView({model:classroomModel});			
					classroomLayoutView.headerRegion.show(headerView);	
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
		},

		startScoresApp: function(classroomLayoutView, readOrEdit){			

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.startScoresApp(classroomLayoutView, readOrEdit);
		
		},

		showClassroomEditActivities: function(classroomLayoutView, classroomId){

			TeacherAccount.TeacherApp.Classroom.EditActivities.Controller.showClassroomEditActivities(classroomLayoutView, classroomId);
			
		},

		showClassroomEditScores: function(classroomLayoutView, classroomId){			

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomEditScores(classroomLayoutView, classroomId);
		
		},

		toggleClassroomCode: function(classroomLayoutView, classroomCode){
		 	if(classroomLayoutView.alertRegion.currentView == null){
				var message = "Classroom code: " + classroomCode;
				var alertModel = new Backbone.Model({message: message, alertClass: "alert-info"});
				var alertView = new TeacherAccount.TeacherApp.AlertView({model: alertModel});
				classroomLayoutView.alertRegion.show(alertView);
			}
			else{
				classroomLayoutView.alertRegion.empty();
			}

		},

		showEditClassroom: function(classroomLayoutView, classroomCode){

			var getUrl = "teacher/classroom?classroom_id=" + classroomCode;
			var jqxhr = $.get(getUrl, function(){
				console.log('get request to get classroom data');
			})
			.done(function(data) {

				if(data.status == "success"){

					var classroom = new Backbone.Model(data.classroom);
					classroom.attributes.errors = {};
					classroom.attributes.editOrNew = "edit";
					
					var classroomView = new TeacherAccount.TeacherApp.ClassroomView({model:classroom});
					classroomLayoutView.mainRegion.show(classroomView);
					
				}
				else{

				}
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});	

		},

		exportData: function(classroomId){

			var getUrl = "teacher/export_data?classroom_id=" + classroomId;
			var jqxhr = $.get(getUrl, function(){
				console.log('get request to get classroom data');
			})
			.done(function(data) {

				if(data.status == "success"){

					var classroom = new Backbone.Model(data.classroom);
					classroom.attributes.errors = {};
					classroom.attributes.editOrNew = "edit";
					
					var classroomView = new TeacherAccount.TeacherApp.ClassroomView({model:classroom});
					classroomLayoutView.mainRegion.show(classroomView);
					
				}
				else{

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