//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.Scores", function(Scores, TeacherAccount, Backbone, Marionette, $, _){


	Scores.SearchBarView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_SearchBar"],			
		className: "col-sm-5",
		triggers: {
			"submit [ui-search-form]":"filter:search:classroom:scores:view"
		},
		ui:{
			searchInput: "[ui-search-input]"
		}
	});

	

	

	Scores.StudentPerformanceView = Marionette.ItemView.extend({
		tagName: "tr",
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_StudentPerformance"],
		initialize : function (options) {
			this.model.attributes.activities = options.activities;
	    this.model.attributes.activitiesCount = options.activities.length;	    

	    this.model.attributes.activitiesDue = options.activitiesDue;
	    //count activities with a due date or a performance
	    activitiesIds = [];
	    for(var i = 0; i < this.model.attributes.activities.length; i++){
	    	if(this.model.attributes.activities[i].due_date != null && this.model.attributes.activities[i].due_date != ""){
	    		activitiesIds.push(this.model.attributes.activities[i].id);
	    	}
	    }
	    for(var i = 0; i < this.model.attributes.student_performance.length; i++){
	    	if(this.model.attributes.student_performance[i] != null){
		    	activitiesIds.push(this.model.attributes.student_performance[i].activity_id);
	    	}
	    }

	    this.model.attributes.activitiesDue = $.unique(activitiesIds).length


	    this.model.attributes.proficiency = 
	    	this.model.attributes.activitiesDue == 0 ? "-" : Math.round(100*this.model.attributes.proficient_count/this.model.attributes.activitiesDue,1);

	    if(this.model.attributes.proficiency >= 80) {
    		this.model.attributes.proficiency_color = 'success-sown';
    	}
	    else if(this.model.attributes.proficiency >= 60) {
    		this.model.attributes.proficiency_color = 'warning-sown';
    	}
	    else if(this.model.attributes.proficiency < 60) {
    		this.model.attributes.proficiency_color = 'danger-sown';
    	}
    	else{
	    		this.model.attributes.proficiency_color = 'none';
    	}

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
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_StudentPerformanceEdit"],

		initialize : function (options) {
	    this.model.attributes.parentActivities = options.activities;

	  }
	});

	Scores.EditScoresView = Marionette.CompositeView.extend({
		tagName: "div",
		className: "classroom-tab-content",
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_EditScores"],																		 
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

		initialize: function(){
		//TODO: THIS IS A HACK, FIND THE WAY TO GET THE COLLECTION SIZE IN A COMPOSITE VIEW AND GET RID OF THIS
			if(this.model == null){
				this.model = new Backbone.Model({});
			}
			this.model.attributes.collectionSize = this.collection.length;
		}

		

		
	})

	Scores.ScoresView = Marionette.CompositeView.extend({
		tagName: "div",
		className: "classroom-tab-content",
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_Scores"],
		childView: Scores.StudentPerformanceView,
		childViewContainer: "tbody",
		childViewOptions: function(model, index){			
			return {
				activities: this.model.attributes.activities,

			}
		},

		ui:{
			studentHeader: "[ui-student-header]",
			masteryHeader: "[ui-mastery-header]",
			newActivityButton: "[ui-new-activity-button]",
			saveNewActivityButton: "[ui-save-new-activity-button]",
			newActivityForm: "[ui-new-activity-form]"
		},

		events: {
			// "dblclick .activity": "sortActivityHeader",
			"click .ui_scores-table__sort_icon": "sortActivityHeader",
			"click @ui.studentHeader": "sortByName",
			"click @ui.masteryHeader" : "sortByMastery"
		},

		triggers:{
			"click @ui.saveNewActivityButton": "save:new:activity"
		},

		sortByName: function(){
			this.collection.comparator = function(item){
				return [item.get("last_name"), item.get("first_name")];
				
			}
			this.collection.sort();
		},

		sortByMastery: function(e){
			e.preventDefault();
			this.collection.comparator = function(item){
				return -[parseInt(item.get("proficiency"))];
				
			}
			this.collection.sort();
		},

		stopPropagation: function(e){
			console.log("mousedown");
			e.stopPropagation();			
		},

		sortActivityHeader: function(e){
			console.log(e);
			e.preventDefault();

			index = parseInt($(e.target).parent().attr("id").replace("header_",""));
			
			this.collection.comparator = function(item){
				
				
				if(item.attributes.student_performance[index]){
					
					if(item.attributes.student_performance[index].activity_type == 'scored'){
						return -item.attributes.student_performance[index].performance_pretty;
					}				
					else if (item.attributes.student_performance[index].activity_type == 'completion'){
						if(item.attributes.student_performance[index].completed_performance == 't'){
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
				else{
					return Number.MAX_VALUE;
				}
			};

			this.collection.sort();
			this.render();
		},

		initialize: function(model, collection){
			//TODO: THIS IS A HACK, FIND THE WAY TO GET THE COLLECTION SIZE IN A COMPOSITE VIEW AND GET RID OF THIS
			if(this.model == null){
				this.model = new Backbone.Model({});
			}
			this.model.attributes.collectionSize = this.collection.length;

			//create a data structure for storing the sorted list of activities
			this.model.attributes.activitiesSortOrder = [];
			for(var i=0; i < this.model.attributes.activities.length; i++){
				this.model.attributes.activitiesSortOrder[i] = this.model.attributes.activities[i].classroom_activity_pairing_id;
			}


		},

		onRender: function(){
			if(this.model.attributes.searchTerm == null && this.model.attributes.tagId == null)
				this.initializeDragTable();
		},

		onShow: function(){
			if(this.model.attributes.searchTerm == null && this.model.attributes.tagId == null)
				this.initializeDragTable();
		},

		initializeDragTable: function(){
			var obj = this;
			$('#perf_table').dragtable(
				{
					persistState: function(table){
						obj.saveActivitiesSortOrder(table, obj);
					},
					dragaccept: '.scores-table__activity-header_draggable',
					maxMovingRows: 1,
					dragHandle: '.scores-table__activity-name-div'
				}
			);
		},

		saveActivitiesSortOrder: function(table, obj){

			var index = 0;
			//loop through each <th> tag in the table
			table.el.find('th').each(function(i) { 
	      if($(this).hasClass('draggable')) { //ignore the rows without and id
	      	table.sortOrder["classroom_activities_sorted[" + index +"]"]=$(this).attr("name");
	      	index++;
	      } 
	    }); 
	    obj.model.attributes.activitiesSortOrder = table.sortOrder;
	    console.log(obj.model);
			if((obj.model.attributes.searchTerm == null || obj.model.attributes.searchTerm == "") && (obj.model.attributes.tagIds == null || obj.model.attributes.tagIds.length == 0)){
				console.log("try to save sort order");
	    	this.triggerMethod("save:activities:sort:order");
			}

		}

	});

	Scores.LayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_Layout"],			
		regions:{			
			searchBarRegion: "#search_bar_region",
			tagsRegion: "#tags_region",
			scoresRegion: '#scores_region',
			modalRegion: '#modal_region'
		},

		className:"col-md-12",

		ui: {
			modalRegion: "#modal_region"
		},

		childViewOptions: function(model, index){			
			return {searchTerm: this.model.attributes.searchTerm, tagId: this.model.attributes.tagId}
		},

		onChildviewFilterSearchClassroomScoresView: function(view){
			
			//re-render the header to clear any tags
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomTagCollectionView(this, this.model.attributes.classroomId);

			if(this.model.get("readOrEdit") == "read")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomScores(this, this.model.attributes.classroomId, view.ui.searchInput.val(), null);
			else if(this.model.get("readOrEdit") == "edit")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomEditScores(this, this.model.attributes.classroomId, view.ui.searchInput.val(), null);
		},

		onChildviewFilterTagClassroomScoresView: function(view){

			//change the color of the tag
			if(view.ui.label.hasClass("selected_tag")){
				view.ui.label.removeClass("selected_tag");
				
				var index = $.inArray(view.model.attributes.id, this.model.attributes.tags);
				this.model.attributes.tags.splice(index, 1);

			}
			else{

				view.ui.label.addClass("selected_tag");
				this.model.attributes.tags.push(view.model.attributes.id);

			}

			if(this.model.get("readOrEdit") == "read")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomScores(this, this.model.attributes.classroomId, null, this.model.attributes.tags);
			else if(this.model.get("readOrEdit") == "edit")
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.showClassroomEditScores(this, this.model.attributes.classroomId, null, this.model.attributes.tags);
		},

		onChildviewScoresLayoutOpenVerifyModal: function(view){
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.showVerifyModal(this, view.model.get("studentPerformanceId"));
		},

		onChildviewScoresLayoutSaveVerify: function(view){
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveVerify(this, view.ui.verifyForm);
		},

		onChildviewSaveClassroomScores: function(view){			
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveClassroomScores(this, view.ui.studentPerformanceForm);
		},

		onChildviewSaveActivitiesSortOrder: function(view){

	    TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveActivitiesSortOrder(this, view, view.model.attributes.activitiesSortOrder);

		},

		onChildviewSaveNewActivity: function(view){
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveNewActivity(view.ui.newActivityForm, this);
		}

	});

Scores.VerifyModalView = Marionette.ItemView.extend({
	template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_VerifyModal"],
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