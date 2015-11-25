//= require teacher/teacher

TeacherAccount.module("TeacherApp.Students", function(Students, TeacherAccount, Backbone, Marionette, $, _){

	Students.Controller = {
	

		/*
		 * THIS IS LIKELY TO BE DEPRECATED. DON'T USE
		 * Not sure teachers find it useful to see a list of all their students, so probably will get rid of this
		 *
		 */
		showIndexCompositeView: function(searchTerm){

			// create activity assignment view and add it to the layout
			var getUrl = "/teacher/students?";			
			if(searchTerm != null){
				getUrl += "searchTerm=" + encodeURIComponent(searchTerm);
			}
			
			var jqxhr = $.get(getUrl, function(){
				console.log('get request list of students');
			})
			.done(function(data) {

				var model = new Backbone.Model({searchTerm: searchTerm});
				var studentsCollection = new Backbone.Collection(data.students);

				var indexCompositeView = new TeacherAccount.TeacherApp.Students.IndexCompositeView({collection: studentsCollection, model:model});

				var studentsLayoutView = new TeacherAccount.TeacherApp.Students.StudentsLayoutView({model:model});
				TeacherAccount.rootView.mainRegion.show(studentsLayoutView);

				studentsLayoutView.mainRegion.show(indexCompositeView);
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

		showStudentView: function(studentUserId, classroomId){

			TeacherAccount.navigate("students/show/" + (studentUserId ? studentUserId : 'null') + "/" + (classroomId ? classroomId : 'null'));

			var studentsLayout;

			var jqxhr = $.get("/teacher/student?student_user_id=" + studentUserId + "&classroom_id=" + classroomId, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
				console.log(data);

	     	if(data.status == "success"){

					// Create a Layout Container and render it
					var studentsLayoutModel = new Backbone.Model({student: data.student});
					studentsLayout = new Students.StudentsLayoutView({model: studentsLayoutModel});

					TeacherAccount.rootView.mainRegion.show(studentsLayout);
				}else{
					studentsLayout = new Students.StudentsLayoutView();
					TeacherAccount.rootView.mainRegion.show(studentsLayout);
				}

				// Create the search view
				var jqxhr2 = $.get("/teacher/students", function(){
					console.log('get request for classroom model');
				})
				.done(function(data2) {
					console.log(data2);

		     	if(data2.status == "success"){

		     		var studentsViewAsSearchModel = new Backbone.Model({
		     			student: data.student, 
		     			students: data2.students,
		     			searchStudentUserId: studentUserId,
		     			searchClassroomId: classroomId
		     		});

		     		var students = [];
		     		data2.students.map(function(s){
		     			for(var i = 0; i < s.classrooms.length; i++){
		     				students.push(s.display_name + ': ' + s.classrooms[i].name);

		     			}
		     		});

		     		studentsViewAsSearchModel.set("student_names_classrooms", students);

						var studentsViewAsSearchView = new Students.StudentsViewAsSearchView({model: studentsViewAsSearchModel});

						studentsLayout.viewAsRegion.show(studentsViewAsSearchView);

		     	}
		     	
			  })
			  .fail(function() {
			  	console.log("error");
			  })
			  .always(function() {
			   
				});

				// Post request to set the student_user_id session variable
				var postData = "student_user_id=" + studentUserId + "&classroom_id=" + classroomId;
				var jqxhr = $.post("/teacher/become_student", postData, function(){
					console.log('get request for classroom model');
				})
				.done(function(data) {
					console.log(data);

		     	if(data.status == "success"){

						var classroom = new Backbone.Model({classroomId: classroomId, tags: []})
						var classroomLayout = new StudentAccount.StudentApp.Classroom.LayoutView({model: classroom});			

						studentsLayout.studentViewRegion.show(classroomLayout);

						StudentAccount.StudentApp.Classroom.Controller.showClassroomHeader(classroomLayout,classroomId, 'scores');

						StudentAccount.StudentApp.Classroom.Controller.showClassroomScores(classroomLayout,classroomId);	

		     	}
		     	
			  })
			  .fail(function() {
			  	console.log("error");
			  })
			  .always(function() {
			   
				});

	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},


		
		openRemoveStudentModal: function(layoutView, studentId, classroomId){
			var getURL = "/teacher/classroom_student_user?" 
				+ "classroom_id=" + classroomId
				+ "&student_user_id=" + studentId;
			var jqxhr = $.get(getURL, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {
	     		console.log(data);
	     	if(data.status == "success"){

	     		var classroomStudentUserModel = new Backbone.Model(data.classroom_student_user);
	     		var removeStudentConfirmationModalView = new TeacherAccount.TeacherApp.Students.RemoveStudentConfirmationModalView({model: classroomStudentUserModel});
	     		layoutView.modalRegion.show(removeStudentConfirmationModalView);
	     		layoutView.ui.modalRegion.modal("show");

					
	     	}
	     	
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			
		},

		removeStudent: function(layoutView, classroomStudentUserId, studentUserId, classroomId){
			var postURL = "/teacher/classroom_remove_student" 

			var postData = "classroom_id=" + classroomId
				+ "&student_user_id=" + studentUserId
				+ "&classroom_student_user_id=" + classroomStudentUserId;
			var jqxhr = $.post(postURL, postData, function(){
				console.log('get request for classroom model');
			})
			.done(function(data) {

				this.layoutView.ui.modalRegion.modal("hide");
				Students.Controller.showStudentView(null, null);

	     	if(data.status == "success"){

					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-success", message: "Student successfully removed!"});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model:alertModel});

					TeacherAccount.rootView.alertRegion.show(alertView);

	     	}else{

					var alertModel = new TeacherAccount.Models.Alert({alertClass: "alert-danger", message: "Sorry, there was an error removing the student."});
					var alertView = new TeacherAccount.TeacherApp.AlertView({model:alertModel});

					TeacherAccount.rootView.alertRegion.show(alertView);

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