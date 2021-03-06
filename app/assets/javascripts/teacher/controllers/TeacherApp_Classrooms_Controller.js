//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classrooms", function(Classrooms, TeacherAccount, Backbone, Marionette, $, _){

	Classrooms.Controller = {

		showClassroomOverviews: function(){
			console.log("preparing classroom overview");
			
			TeacherAccount.navigate("classrooms");
			//query for model data
			var jqxhr = $.get("/classrooms_summary", function(){
				console.log('get request made');
			})
			.done(function(data) {

				console.log(data);
	     	
	     	if(data.status == "success"){
	     		var collection = new Backbone.Collection(data.classrooms);
	     		var model = new Backbone.Model(data);
	     		var classroomWidgetRowView = new TeacherAccount.TeacherApp.Classrooms.ClassroomWidgetRowView({collection: collection, model: model});					     	
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