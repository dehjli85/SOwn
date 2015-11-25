//= require teacher/teacher

TeacherAccount.module("TeacherApp.Students", function(Students, TeacherAccount, Backbone, Marionette, $, _){

	Students.IndexStudentView = Marionette.ItemView.extend({

		template: JST["teacher/templates/Students/TeacherApp_Students_IndexStudent"],
		tagName: "tr",

		ui:{
			studentNameLink: "[ui-student-name-link]",			
		},

		triggers:{

		},

		events:{
			"click .ui-classroom-link": "showStudentView",
			"click .ui_remove_link": "showRemoveModal"
		},

		showStudentView: function(e){
			e.preventDefault();
			this.model.attributes.classroomId = $(e.target).attr("id");
			this.triggerMethod("show:student:view");
		},

		showRemoveModal: function(e){
			e.preventDefault();
			this.model.attributes.classroomId = $(e.target).attr("id");
			this.triggerMethod("show:remove:modal");
		}

	});


	Students.IndexCompositeView = Marionette.CompositeView.extend({

		template: JST["teacher/templates/Students/TeacherApp_Students_IndexComposite"],
		tagName: "div",
		className: "col-md-12",
		childView: TeacherAccount.TeacherApp.Students.IndexStudentView,
		childViewContainer: "tbody",
		ui:{
			searchForm: "[ui-search-form]",
			searchInput: "[ui-search-input]"
		},

		events:{
			"submit @ui.searchForm": "searchStudents"
		},

		initialize: function(){

			//TODO: THIS IS A HACK, FIND THE WAY TO GET THE COLLECTION SIZE IN A COMPOSITE VIEW AND GET RID OF THIS
			if(this.model == null){
				this.model = new Backbone.Model({});
			}
			this.model.attributes.collectionSize = this.collection.length;

			//sort by last name
			this.collection.comparator = function(item){
				return [item.get("last_name"), item.get("first_name")];
				
			}
			this.collection.sort();
		},

		searchStudents: function(e){
			e.preventDefault();
			TeacherAccount.TeacherApp.Students.Controller.showIndexCompositeView(this.ui.searchInput.val())
		},

		

	});	


	Students.StudentsLayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/Students/TeacherApp_Students_StudentsLayout"],
		regions: { 
			viewAsRegion: "#view_as_region",
			studentViewRegion: "#student_view_region",
			modalRegion: "#student_layout_modal_region"
		},

		className: "col-md-12",

		ui:{
			modalRegion: "#student_layout_modal_region"
		},

		onChildviewLayoutSearchStudent: function(studentsViewAsSearchView){
			Students.Controller.showStudentView(studentsViewAsSearchView.model.get("searchStudentUserId"), studentsViewAsSearchView.model.get("searchClassroomId"));
		},

		onChildviewOpenRemoveStudentModal: function(studentsViewAsSearchView){
			Students.Controller.openRemoveStudentModal(this, studentsViewAsSearchView.model.get("searchStudentUserId"), studentsViewAsSearchView.model.get("searchClassroomId"));
		},

		onChildviewRemoveStudent: function(removeStudentConfirmationModalView){
			Students.Controller.removeStudent(this, removeStudentConfirmationModalView.model.get("id"), removeStudentConfirmationModalView.model.get("student_user_id"), removeStudentConfirmationModalView.model.get("classroom_id"));
		}

	});

	Students.StudentsViewAsSearchView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Students/TeacherApp_Students_StudentsViewAsSearch"],
		className: "col-sm-12 view-as-div",
		ui:{
			studentSearchForm: "[ui-student-search-form]",
			studentSearchInput: "[ui-student-search-input]",
			studentSearchButton: "[ui-student-search-button]",
			removeStudentLink: "[ui-remove-student-link]"
		},

		events:{
			"submit @ui.studentSearchForm": "searchStudent"
		},

		triggers:{
			"click @ui.removeStudentLink": "open:remove:student:modal"
		},

		onShow: function(){
			this.ui.studentSearchInput.typeahead({
			  hint: true,
			  highlight: true,
			  minLength: 1
			},
			{
			  name: 'student_names_classrooms',
			  source: this.substringMatcher(this.model.get("student_names_classrooms"))
			});

			$('.twitter-typeahead').css("display", "");

		},

		searchStudent: function(e){
			e.preventDefault();

			// find the students/classroom matching the input
			var students = this.model.get("students");
			for(var i = 0; i < students.length; i++){
				for(var j = 0; j < students[i].classrooms.length; j++){
					if(students[i].display_name + ': ' + students[i].classrooms[j].name == this.ui.studentSearchInput.val()){
						this.model.set("searchStudentUserId", students[i].id);
						this.model.set("searchClassroomId", students[i].classrooms[j].id);
						this.triggerMethod("layout:search:student")
					}
				}
			}


		},

		substringMatcher: function(strs) {
		  return function findMatches(q, cb) {
		    var matches, substringRegex;

		    // an array that will be populated with substring matches
		    matches = [];

		    // regex used to determine if a string contains the substring `q`
		    substrRegex = new RegExp(q, 'i');

		    // iterate through the pool of strings and for any string that
		    // contains the substring `q`, add it to the `matches` array
		    $.each(strs, function(i, str) {
		      if (substrRegex.test(str)) {
		        matches.push(str);
		      }
		    });

		    cb(matches);
		  }
		},

	});

	Students.RemoveStudentConfirmationModalView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Students/TeacherApp_Students_RemoveStudentConfirmationModal"],
		className: "modal-dialog",

		ui:{
			removeButton: "[ui-remove-button]"
		},

		triggers: {
			"click @ui.removeButton": "remove:student"
		},
		
		initialize: function(options){
			this.$el.attr("role","document");
		}, 





	});




	

});