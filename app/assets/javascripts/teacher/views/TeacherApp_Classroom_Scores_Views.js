//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.Scores", function(Scores, TeacherAccount, Backbone, Marionette, $, _){


	Scores.SearchBarView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_SearchBar"],			
		className: "col-sm-5",
		triggers: {
			"submit [ui-search-form]":"filter:search:classroom:scores:view"
		},
		ui:{
			searchInput: "[ui-search-input]"
		}
	});

	Scores.TagView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_Tag"],			
		tagName: "li",
		triggers: {
			"click a":"filter:tag:classroom:scores:view"			
		}
		
	});

	Scores.TagCollectionView = Marionette.CollectionView.extend({
		childView: Scores.TagView,
		tagName: "ul",
		className: "list-inline col-sm-12",		
	});

	Scores.StudentPerformanceView = Marionette.ItemView.extend({
		tagName: "tr",
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_StudentPerformance"],
		initialize : function (options) {
	    this.model.attributes.activitiesCount = options.activitiesCount;	    
	  }
	});

	Scores.StudentPerformanceEditView = Marionette.ItemView.extend({
		tagName: "tr",
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_StudentPerformanceEdit"],

		initialize : function (options) {
	    this.model.attributes.parentActivities = options.activities;
	    console.log(this.model);	    

	  }
	});

	Scores.EditScoresView = Marionette.CompositeView.extend({
		tagName: "div",
		className: "classroom-tab-content",
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_EditScores"],																		 
		childView: Scores.StudentPerformanceEditView,
		childViewContainer: "tbody",
		childViewOptions: function(model, index){			
			return {activities: this.model.attributes.activities}
		},

		ui:{
			studentHeader: "[ui-student-header]",
			studentPerformanceForm: "[ui-scores-form]"
		},

		events:{
			"submit @ui.studentPerformanceForm": "saveClassroomScores"
		},

		saveClassroomScores: function(e){
			e.preventDefault();
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveClassroomScores(this.ui.studentPerformanceForm);
		}

		
	})

	Scores.ScoresView = Marionette.CompositeView.extend({
		tagName: "div",
		className: "classroom-tab-content",
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_Scores"],
		childView: Scores.StudentPerformanceView,
		childViewContainer: "tbody",
		childViewOptions: function(model, index){			
			return {activitiesCount: this.model.attributes.activities.length}
		},

		ui:{
			studentHeader: "[ui-student-header]"
		},

		events: {
			"click .activity_header": "sortActivityHeader",
			"click @ui.studentHeader": "sortByName"
		},

		sortByName: function(){
			console.log(this.collection);
			this.collection.comparator = function(item){
				return [item.get("student").last_name, item.get("student").first_name];
				
			}
			this.collection.sort();
		},

		sortActivityHeader: function(e){

			index = parseInt($(e.target).attr("id").replace("header_",""));
			console.log(index);
			
			this.collection.comparator = function(item){
				
				
				if(item.attributes.student_performance[index]){
					
					if(item.attributes.student_performance[index].activity_type == 'scored'){
						return -item.attributes.student_performance[index].performance_pretty;
					}				
					else if (item.attributes.student_performance[index].activity_type == 'completion'){
						if(item.attributes.student_performance[index].completed_performance == 't'){
							console.log('completed!');
							return 0;
						}							
						else{
							return 1;							
						}
					}
					else{
						return Number.MAX_VALUE;
					}

				}
				else
					return Number.MAX_VALUE;

			};

			this.collection.sort();
			// console.log(this.collection);	
		}

	});

	Scores.LayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_Layout"],			
		regions:{			
			searchBarRegion: "#search_bar_region",
			tagsRegion: "#tags_region",
			scoresRegion: '#scores_region'
		},

		onChildviewFilterSearchClassroomScoresView: function(view){
			
			if(this.model.get("readOrEdit") == "read")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomScores(TeacherAccount.rootView.mainRegion.currentView, this.model.attributes.classroomId, view.ui.searchInput.val(), null);
			else if(this.model.get("readOrEdit") == "edit")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomEditScores(TeacherAccount.rootView.mainRegion.currentView, this.model.attributes.classroomId, view.ui.searchInput.val(), null);
		},

		onChildviewFilterTagClassroomScoresView: function(view){
			if(this.model.get("readOrEdit") == "read")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomScores(TeacherAccount.rootView.mainRegion.currentView, this.model.attributes.classroomId, null, view.model.id);
			else if(this.model.get("readOrEdit") == "edit")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomEditScores(TeacherAccount.rootView.mainRegion.currentView, this.model.attributes.classroomId, null, view.model.id);
		}

	})

	

	

});