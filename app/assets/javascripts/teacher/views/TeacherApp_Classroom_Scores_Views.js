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

			this.model.set("classroomId", options.classroomId);

			this.model.set("activities", options.activities);
	    this.model.set("activitiesCount",  options.activities.length);	    

    	this.model.set("proficiency", this.model.get("mastery_percentage") == null ? "-" : Math.round(100*this.model.get("mastery_percentage"),1));

	    if(this.model.get("proficiency") >= 80) {
    		this.model.set("proficiency_color", 'success-sown');
    	}
	    else if(this.model.get("proficiency") >= 60) {
    		this.model.set("proficiency_color", 'warning-sown');
    	}
	    else if(this.model.get("proficiency") < 60) {
    		this.model.set("proficiency_color", 'danger-sown');
    	}
    	else{
	    		this.model.set("proficiency_color", 'none');
    	}

	  },

	  ui:{
	  	verifyLink: "[ui-verify-a]",
	  	studentLink: "[ui-student-link]"
	  },

	  events:{
	  	"click @ui.verifyLink": "triggerOpenVerifyModal",
	  },

	  triggers:{
	  	"click @ui.studentLink": "show:student:page"
	  },



	  triggerOpenVerifyModal: function(e){
	  	e.preventDefault();
	  	this.model.set("studentPerformanceId", $(e.target).attr("name"));
	  	this.triggerMethod("scores:layout:open:verify:modal");
	  }
	});

	Scores.StudentPerformanceEditView = Marionette.ItemView.extend({
		tagName: "tr",
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_StudentPerformanceEdit"],

		initialize : function (options) {
	    this.model.set("parentActivities", options.activities);

	  }
	});

	Scores.EditScoresView = Marionette.CompositeView.extend({
		tagName: "div",
		className: "classroom-tab-content",
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_EditScores"],																		 
		childView: Scores.StudentPerformanceEditView,
		childViewContainer: "tbody",
		childViewOptions: function(model, index){			
			return {activities: this.model.get("activities")}
		},

		ui:{
			studentHeader: "[ui-student-header]",
			studentPerformanceForm: "[ui-scores-form]",
			saveButton: "[ui-save-button]",
			scoresTable: "[ui-scores-table]",
			tableContainer: "[ui-table-container]",
			frozenColumnsContainer: "[ui-frozen-columns-container]"
		},

		triggers:{
			"click @ui.saveButton": "save:classroom:scores"
		},

		initialize: function(){
		//TODO: THIS IS A HACK, FIND THE WAY TO GET THE COLLECTION SIZE IN A COMPOSITE VIEW AND GET RID OF THIS
			if(this.model == null){
				this.model = new Backbone.Model({});
			}
			this.model.set("collectionSize", this.collection.length);
		},

		onDomRefresh: function(){
			var obj = this;

			// totally a hack... there's some race condition happening that will mess up the sizes of the divs
			// in the freezeStudentNameColumn function
			setTimeout(function(){obj.freezeStudentNameColumn()}, 1000);

		},

		freezeStudentNameColumn: function(){
			
			var tableContainer = this.ui.tableContainer;
			var frozenColumnsContainer = this.ui.frozenColumnsContainer;

			var table = this.ui.scoresTable;
			var trs = table.find('tr');

			frozenColumnsContainer.css("position:relative");
			frozenColumnsContainer.css("top", table.position().top);
		  frozenColumnsContainer.css("left", table.position().left-1);

			for(var i = 0; i < trs.length; i++){
    
		    //get the first column cell
				var columns = $(trs[i]).find("td,th");
				var col1 = $(columns[0]);
				
		    //create a new div for the cell
		    var divCell = $('<div></div>');
		    var innerDiv =$('<div>' + col1.html() + '</div>'); 
		    innerDiv.appendTo(divCell);

				//add the div to the body
		    divCell.appendTo(this.ui.frozenColumnsContainer);
		    
		    //set the position, width, and height of the div on top of the original cell
		    divCell.css("position", "absolute");
		    divCell.css("top", col1.position().top+1);
		    // divCell.css("left", col1.position().left+50);
		    divCell.css("left", col1.position().left-1);

		    //style the cell
				divCell.css({"background-color": "#FFFFFF",
					"border-bottom": "1px solid #CCCCCC",    
					"border-right": "1px solid #CCCCCC",    
					"border-left": "2px solid #CCCCCC",    
					"padding": "5px",
					"font-size": "12px"});

				if(i == 0){
		    	innerDiv.css({"position": "absolute", "bottom": "2px", "display": "table-cell", "right": "5px"});
		    	divCell.css({"border-bottom": "2px solid #CCCCCC"});
				}
				if(i == 1){
		    	innerDiv.css({"position": "absolute", "bottom": "2px", "display": "table-cell", "right": "5px", "font-style": "italic"});
		    	divCell.css({"border-bottom": "2px solid #CCCCCC"});
				}

		    divCell.outerWidth(col1.outerWidth()+2);
		    divCell.outerHeight(col1.outerHeight());  

			}

	  },

	})

	Scores.ScoresView = Marionette.CompositeView.extend({
		tagName: "div",
		className: "classroom-tab-content",
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_Scores"],
		childView: Scores.StudentPerformanceView,
		childViewContainer: "tbody",
		childViewOptions: function(model, index){			
			return {
				activities: this.model.get("activities"),
				classroomId: this.model.get("classroom").id
			}
		},

		ui:{
			studentHeader: "[ui-student-header]",
			masteryHeader: "[ui-mastery-header]",
			newActivityButton: "[ui-new-activity-button]",
			assignActivitiesButton: "[ui-assign-activities-button]",
			newActivityForm: "[ui-new-activity-form]",
			scoresTable: "[ui-scores-table]",
			tableContainer: "[ui-table-container]",
			frozenColumnsContainer: "[ui-frozen-columns-container]",
		},

		events: {
			"click .ui_scores-table__sort_icon": "sortActivityHeader",
			"click @ui.studentHeader": "sortByName",
			"click @ui.masteryHeader" : "sortByMastery",
			"click .ui-activity-name-link": "openEditActivityDialog"
		},

		triggers:{
			"click @ui.newActivityButton": "open:new:activity:dialog",
			"click @ui.assignActivitiesButton": "open:assign:activities:dialog",
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
			this.model.set("collectionSize", this.collection.length);

			//create a data structure for storing the sorted list of activities
			var activitiesSortOrder = [];
			for(var i=0; i < this.model.get("activities").length; i++){
				activitiesSortOrder[i] = this.model.get("activities")[i].classroom_activity_pairing_id
			}
			this.model.set("activitiesSortOrder", activitiesSortOrder);

		},

		onRender: function(){
			if(this.model.get("searchTerm") == null && this.model.get("tagId") == null)
				this.initializeDragTable();

			
		},

		onShow: function(){
			if(this.model.get("searchTerm") == null && this.model.get("tagId") == null)
				this.initializeDragTable();

		},

		onDomRefresh: function(){
			var obj = this;

			// totally a hack... there's some race condition happening that will mess up the sizes of the divs
			// in the freezeStudentNameColumn function
			setTimeout(function(){obj.freezeStudentNameColumn()}, 1000);

		},


		initializeDragTable: function(){
			var obj = this;
			this.ui.scoresTable.dragtable(
				{
					persistState: function(table){
						obj.saveActivitiesSortOrder(table, obj);
					},
					dragaccept: '.scores-table__activity-header_draggable',
					maxMovingRows: 1,
					dragHandle: '.scores-table__drag-icon', 
					scrollContainer: this.ui.tableContainer
				}
			);
		},

		freezeStudentNameColumn: function(){
			
			var tableContainer = this.ui.tableContainer;
			var frozenColumnsContainer = this.ui.frozenColumnsContainer;

			var table = this.ui.scoresTable;
			var trs = table.find('tr');

			frozenColumnsContainer.css("position:relative");
			frozenColumnsContainer.css("top", table.position().top);
		  frozenColumnsContainer.css("left", table.position().left-1);

			for(var i = 0; i < trs.length; i++){
    
		    //get the first column cell
				var columns = $(trs[i]).find("td,th");
				var col1 = $(columns[0]);
				
		    //create a new div for the cell
		    var divCell = $('<div></div>');
		    var innerDiv =$('<div>' + col1.html() + '</div>'); 
		    innerDiv.appendTo(divCell);

				//add the div to the body
		    divCell.appendTo(this.ui.frozenColumnsContainer);
		    
		    //set the position, width, and height of the div on top of the original cell
		    divCell.css("position", "absolute");
		    divCell.css("top", col1.position().top+1);
		    // divCell.css("left", col1.position().left+50);
		    divCell.css("left", col1.position().left-1);

		    //style the cell
				divCell.css({"background-color": "#FFFFFF",
					"border-bottom": "1px solid #DDD",    
					"border-right": "2px solid #DDD",    
					"border-left": "2px solid #DDD",    
					"padding": "5px",
					"font-size": "12px"});

				if(i == 0){
		    	innerDiv.css({"position": "absolute", "bottom": "5px", "display": "table-cell"});
		    	divCell.css({"border-bottom": "2px solid #DDD"});
		    	// divCell.css({"border-top": "1px solid #CCCCCC"});

				}

		    divCell.outerWidth(col1.outerWidth()+2);
		    divCell.outerHeight(col1.outerHeight());  

			}

	  },

		saveActivitiesSortOrder: function(table, scoresView){

			var index = 0;
			//loop through each <th> tag in the table
			table.el.find('th').each(function(i) { 
	      if($(this).hasClass('scores-table__activity-header_draggable')) { //ignore the rows without an id
	      	table.sortOrder["classroom_activities_sorted[" + index +"]"]=$(this).attr("name");
	      	index++;
	      } 
	    }); 
	    scoresView.model.set("activitiesSortOrder", table.sortOrder);
			if((scoresView.model.get("searchTerm") == null || scoresView.model.get("searchTerm") == "") && (scoresView.model.get("tagIds") == null || scoresView.model.get("tagIds").length == 0)){
	    	this.triggerMethod("save:activities:sort:order");
			}

		},

		onChildviewShowStudentPage: function(view){

			var model = new Backbone.Model({searchTerm: null});
			var studentsLayoutView = new TeacherAccount.TeacherApp.Students.StudentsLayoutView({model:model});
			TeacherAccount.rootView.mainRegion.show(studentsLayoutView);

			TeacherAccount.TeacherApp.Students.Controller.showStudentView(studentsLayoutView, view.model.get("id"), this.model.get("classroom").id);

	  },

	  openEditActivityDialog:function(e){
	  	
	  	e.preventDefault();

	  	var activityId = $(e.target).attr("id").replace("ui-activity-name-link-","");
	  	this.model.set("activityId", activityId);

	  	this.triggerMethod("open:edit:activity:dialog");
	  },

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

			console.log(this.model.attributes.tags);
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
	    	TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveActivitiesSortOrder(this, view, view.model.get("activitiesSortOrder"));
		},

		onChildviewSaveClassroomActivityAssignments: function(view){
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveClassroomActivityAssignments(this, view.ui.assignmentForm);
		},

		onChildviewOpenNewActivityDialog: function(view){
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.openEditActivityDialog(this);
		},

		onChildviewOpenEditActivityDialog: function(view){
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.openEditActivityDialog(this, view.model.get("activityId"));
		},

		onChildviewOpenAssignActivitiesDialog: function(view){
			TeacherAccount.TeacherApp.Classroom.Scores.Controller.openAssignActivitiesDialog(this);
		},

		onChildviewSaveActivity: function(view){
			view.setModelAttributes();
			if(view.model.get("activity_status") == "New"){
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.saveNewActivity(this, view);
			}
			else if(view.model.get("activity_status") == "Edit"){
				TeacherAccount.TeacherApp.Classroom.Scores.Controller.updateActivity(this, view);
			}
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