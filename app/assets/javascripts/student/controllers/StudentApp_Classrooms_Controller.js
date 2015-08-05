//= require student/student

StudentAccount.module("StudentApp.Classrooms", function(Classrooms, StudentAccount, Backbone, Marionette, $, _){

	Classrooms.Controller = {

		startClassroomsApp: function(){
			
			var classroomsLayoutView = new StudentAccount.StudentApp.Classrooms.ClassroomsLayoutView();
			StudentAccount.rootView.mainRegion.show(classroomsLayoutView);

			Classrooms.Controller.showClassroomsSummary(classroomsLayoutView);

		},

		showClassroomsSummary: function(classroomsLayoutView){

			//query for model data
			var jqxhr = $.get("/student/classrooms_summary", function(){
				console.log('get request made');
			})
			.done(function(data) {

				console.log(data);
	     	
	     	if(data.status == "success"){
	     		
	     		var classroomWidgetRowView = new StudentAccount.StudentApp.Classrooms.ClassroomWidgetRowView({collection: new Backbone.Collection(data.classrooms)});					     	
	  	   	classroomsLayoutView.mainRegion.show(classroomWidgetRowView);
		
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

		showJoinClassModal: function(classroomsLayoutView){

			var emptyModel = new Backbone.Model({classroom: null, error:null});
			var joinClassModalView = new StudentAccount.StudentApp.Classrooms.ClassroomsJoinClassModalView( {model: emptyModel});
			classroomsLayoutView.modalRegion.show(joinClassModalView);
			classroomsLayoutView.ui.modalRegion.modal("show");

		},

		searchClassroomCode: function(joinClassModalView){

			var getUrl = "/student/search_classroom_code?classroom_code=" + encodeURIComponent(joinClassModalView.ui.classroomCodeInput.val());
			var jqxhr = $.get(getUrl, function(){
				console.log('get request made');
			})
			.done(function(data) {

				console.log(data);
	     	
	     	if(data.status == "success"){
	     		
	     		//set model for modal
	     		joinClassModalView.model = new Backbone.Model({classroom:data.classroom, error:null});
		
	     	}
	     	else{

	     		joinClassModalView.model = new Backbone.Model({classroom:null, error:data.message});

	     	}
	     	
     		joinClassModalView.render();

	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		joinClassroom: function(classroomsLayoutView, joinClassModalView){

			var postUrl = "/student/join_classroom";
			var postData = "classroom_id=" + encodeURIComponent(joinClassModalView.model.attributes.classroom.id);
			var jqxhr = $.post(postUrl, postData, function(){
				console.log('post request made');
			})
			.done(function(data) {

				console.log(data);
	     	
	     	if(data.status == "success"){
	     		
	     		classroomsLayoutView.ui.modalRegion.modal("hide");

	     		Classrooms.Controller.showClassroomsSummary(classroomsLayoutView);
	     		
	     			
	     	}
	     	else{

	     		joinClassModalView.model = new Backbone.Model({classroom:null, error:data.message});
     		joinClassModalView.render();


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