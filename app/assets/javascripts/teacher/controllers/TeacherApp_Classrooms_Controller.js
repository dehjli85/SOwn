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

	};

})