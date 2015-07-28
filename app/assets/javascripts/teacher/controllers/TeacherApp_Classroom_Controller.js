//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom", function(Classroom, TeacherAccount, Backbone, Marionette, $, _){

	Classroom.Controller = {

		showClassroomHeader: function(layoutView, id, activeNavPill){

			var jqxhr = $.get("/teacher/classroom?id=" + id, function(){
				console.log('get request made');
			})
			.done(function(data) {

	     	
				var classroomModel = new TeacherAccount.TeacherApp.Classroom.Models.Classroom(data);
				
	     	var headerView = new TeacherAccount.TeacherApp.Classroom.HeaderView({model:classroomModel});			
				layoutView.headerRegion.show(headerView);
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
			
			
			//create the view for the header and show it
		}
	}

})