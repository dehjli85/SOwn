//= require student/student

StudentAccount.module("StudentApp.Classrooms", function(Classrooms, StudentAccount, Backbone, Marionette, $, _){

	Classrooms.Controller = {

		showClassroomOverviews: function(){
			
			//query for model data
			var jqxhr = $.get("/student/classrooms_summary", function(){
				console.log('get request made');
			})
			.done(function(data) {

				console.log(data);
	     	
	     	if(data.status == "success"){
	     		
	     		var classroomWidgetRowView = new StudentAccount.StudentApp.Classrooms.ClassroomWidgetRowView({collection: new Backbone.Collection(data.classrooms)});					     	
	  	   	StudentAccount.rootView.mainRegion.show(classroomWidgetRowView);
		
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

		}

	};

})