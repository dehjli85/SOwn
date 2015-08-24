//= require teacher/teacher

TeacherAccount.module("TeacherApp.Students", function(Students, TeacherAccount, Backbone, Marionette, $, _){

	Students.IndexStudentView = Marionette.ItemView.extend({

		template: JST["teacher/templates/TeacherApp_Students_IndexStudent"],
		tagName: "tr",

		ui:{
			studentNameLink: "[ui-student-name-link]"
		},

		triggers:{

		},

		events:{
			"click .ui-classroom-link": "showStudentView"
		},

		showStudentView: function(e){
			e.preventDefault();
			var classroomId = $(e.target).attr("id");
			TeacherAccount.TeacherApp.Students.Controller.showStudentView(this.model.attributes.id, classroomId);
		},

		onShowStudentView: function(){

		}

	});


	Students.IndexCompositeView = Marionette.CompositeView.extend({

		template: JST["teacher/templates/TeacherApp_Students_IndexComposite"],
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
		}

	});	

	Students.ShowActivityView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Students_ShowActivity"],
		tagName: "tr",

		ui:{
			seeAllButton: "[ui-see-all-a]",
			nameLink: "[ui-name-a]"
		},

		triggers:{
			"click @ui.seeAllButton": "students:layout:show:see:all:modal",
			"click @ui.nameLink": "students:layout:show:activity:details:modal"
		}

	});

	Students.ShowStudentCompositeView = Marionette.CompositeView.extend({
		template: JST["teacher/templates/TeacherApp_Students_ShowStudentComposite"],
		childViewContainer: "tbody",
		childView: TeacherAccount.TeacherApp.Students.ShowActivityView,
		className: "col-md-12",


		

	});

	Students.ShowLayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Students_ShowLayout"],
		regions: { 
			mainRegion: "#show_layout_main_region",
			modalRegion: "#show_layout_modal_region"
		},

		className: "col-md-12",

		ui:{
			modalRegion: "#show_layout_modal_region"
		},

		onChildviewStudentsLayoutShowSeeAllModal: function(view){
			this.ui.modalRegion.modal("show");
			TeacherAccount.TeacherApp.Students.Controller.openSeeAllModal(this,view.model.get("classroom_activity_pairing_id"), this.model.attributes.student.id);
		},

		onChildviewStudentsLayoutShowActivityDetailsModal: function(view){
			this.ui.modalRegion.modal("show");
			TeacherAccount.TeacherApp.Students.Controller.openActivityDetailsModal(this, view.model.get("classroom_activity_pairing_id"), this.model.attributes.student.id);
		}

	})



	

});