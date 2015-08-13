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
	  },

	  ui:{
	  	verifyLink: "[ui-verify-a]"
	  },

	  events:{
	  	"click @ui.verifyLink": "triggerOpenVerifyModal"
	  },

	  triggerOpenVerifyModal: function(e){
	  	e.preventDefault();
	  	this.model.attributes.studentPerformanceId = $(e.target).attr("name");
	  	this.triggerMethod("scores:layout:open:verify:modal");
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

		triggers:{
			"submit @ui.studentPerformanceForm": "saveClassroomScores"
		},

		

		
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
		},

		initialize: function(){
		//TODO: THIS IS A HACK, FIND THE WAY TO GET THE COLLECTION SIZE IN A COMPOSITE VIEW AND GET RID OF THIS
			if(this.model == null){
				this.model = new Backbone.Model({});
			}
			this.model.attributes.collectionSize = this.collection.length;
		}

	});

	Scores.LayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_Layout"],			
		regions:{			
			searchBarRegion: "#search_bar_region",
			tagsRegion: "#tags_region",
			scoresRegion: '#scores_region',
			modalRegion: '#modal_region'
		},

		ui: {
			modalRegion: "#modal_region"
		},

		onChildviewFilterSearchClassroomScoresView: function(view){
			
			if(this.model.get("readOrEdit") == "read")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomScores(this, this.model.attributes.classroomId, view.ui.searchInput.val(), null);
			else if(this.model.get("readOrEdit") == "edit")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomEditScores(this, this.model.attributes.classroomId, view.ui.searchInput.val(), null);
		},

		onChildviewFilterTagClassroomScoresView: function(view){
			if(this.model.get("readOrEdit") == "read")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomScores(this, this.model.attributes.classroomId, null, view.model.id);
			else if(this.model.get("readOrEdit") == "edit")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomEditScores(this, this.model.attributes.classroomId, null, view.model.id);
		},

		onChildviewScoresLayoutOpenVerifyModal: function(view){
			console.log(view);
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.showVerifyModal(this, view.model.get("studentPerformanceId"));
		},

		onChildviewScoresLayoutSaveVerify: function(view){
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveVerify(this, view.ui.verifyForm);
		},

		onChildviewSaveClassroomScores: function(view){			
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveClassroomScores(this, view.ui.studentPerformanceForm);
		}

	});

Scores.VerifyModalView = Marionette.ItemView.extend({
	template: JST["teacher/templates/TeacherApp_Classroom_Scores_VerifyModal"],
	className: "modal-dialog",

	ui:{
		verifyButton: "[ui-verify-button]",
		verifyForm: "[ui-verify-form]"
	},

	triggers: {
		"click @ui.verifyButton": "scores:layout:save:verify"
	},

	initialize: function(options){
		this.$el.attr("role","document");

		if(this.model.attributes.student_performance.performance_date){

			Number.prototype.padLeft = function(base,chr){
			   var  len = (String(base || 10).length - String(this).length)+1;
			   return len > 0? new Array(len).join(chr || '0')+this : this;
			}

			var d = new Date(this.model.attributes.student_performance.performance_date);
      this.model.attributes.student_performance.performance_date 
      	= [ (d.getMonth()+1).padLeft(),
          d.getDate().padLeft(),
          d.getFullYear()].join('/');
 
		}
	},

});

	

	

});