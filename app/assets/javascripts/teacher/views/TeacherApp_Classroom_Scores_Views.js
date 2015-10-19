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
	  	studentLink: "[ui-student-link]",
	  	goalLink: "[ui-goal-a]"
	  },

	  events:{
	  	"click @ui.verifyLink": "triggerOpenVerifyModal",
	  	"click @ui.goalLink": "triggerClassroomScoresShowGoalModal"
	  },

	  triggers:{
	  	"click @ui.studentLink": "show:student:page",
	  },

	  triggerClassroomScoresShowGoalModal: function(e){
	  	e.preventDefault();
	  	this.model.set("classroomActivityPairingId", $(e.target).attr("name"));
	  	this.triggerMethod("classroom:scores:show:goal:modal");
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
		},

		onChildviewClassroomScoresShowGoalModal: function(studentPerformanceView){
		
			// Need to trigger a method to get the classroom layout view 
			this.triggerMethod("classroom:layout:show:goal:modal", studentPerformanceView);

		},

		

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

	Scores.SetGoalModalView = Marionette.LayoutView.extend({
		template: JST ["teacher/templates/Classroom/TeacherApp_Classroom_Scores_SetGoalModal"],
		className: "modal-dialog",
		
		regions:{
			graphRegion: "[ui-bar-graph-region]",
			goalRegion: "[ui-goal-region]"
		},

		ui:{
			saveButton: "[ui-save-button]",
			goalForm: "[ui-goal-form]",
			addReflectionLink: "[ui-add-reflection-link]",
			reflectionDiv: "[ui-reflection-div]",
			scoreGoalInput: "[ui-score-goal-input]",
			scoreGoalLink: "[ui-score-goal-link]",
			goalDateInput: "[ui-goal-date-input]",
			goalDateLink: "[ui-goal-date-link]",
		},

		events:{
			"click @ui.addReflectionLink": "revealReflectionDiv",
			"click @ui.scoreGoalLink": "revealScoreGoalInput",
			"click @ui.goalDateLink": "revealGoalDateInput"
		},

		triggers:{
			"click @ui.saveButton": "save:reflection"
		},


		initialize: function(options){
			this.$el.attr("role","document");			
		},

		revealReflectionDiv: function(e){
			e.preventDefault();
			this.ui.reflectionDiv.css("display", "block");
			this.ui.addReflectionLink.css("display","none");
		},

		revealScoreGoalInput: function(e){
			e.preventDefault();
			this.ui.scoreGoalLink.css("display", "none");
			this.ui.scoreGoalInput.css("display", "inline");
		},

		revealGoalDateInput: function(e){
			e.preventDefault();
			this.ui.goalDateLink.css("display", "none");
			this.ui.goalDateInput.css("display", "inline");
		},

		goalEmpty: function(){
			return this.ui.scoreGoalInput.val().trim().length == 0 && this.ui.goalDateInput.val().trim().length == 0;
		}


	});

	/*
	 * This view requires a model with the following attributes:
	 *	=> data: json object with fields (arrays) "x", "y", and "color"
	 *  => labels: json object with fields (strings) "x" and "y"
	 */
	Scores.PerformanceBarGraphView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_PerformanceBarGraph"],
		ui:{
			barGraphDiv: "[ui-bar-graph-div]",
			rangeGraphDiv: "[ui-range-graph-div]",
			performanceGraphDiv: "[ui-performance-graph-div]"
		},

		onShow: function(){
			var config_obj = {
				width: this.model.get("width"),
				height: this.model.get("height"),
				score_range: this.model.get("score_range")
			}
			console.log(config_obj);
			this.showBarGraph(config_obj);
		},

		/*
		 * Any object can be passed with the following fields and types
		 * height: integer representing pixel height of the bar graph
		 * width: integer representing pixel width of the bar graph
		 * score_range: JSON object with fields min_score, benchmark1_score, benchmark2_score, and maximum_score
		 */
		showBarGraph: function(config_obj){

			// CREATE THE SCORE RANGE GRAPH
			if(config_obj.score_range.min_score != null && config_obj.score_range.max_score != null){
				var margin_range = {top: 20, right: 20, bottom: 30, left: 40},
				    width_range = 150 - margin_range.left - margin_range.right,
				    height_range = (config_obj && config_obj.height ? config_obj.height : 200) - margin_range.top - margin_range.bottom;

				var x_range = d3.scale.ordinal()
				    .rangeRoundBands([0, width_range], .1);

				var y_range = d3.scale.linear()
				    .range([height_range, 0]);

				var xAxis_range = d3.svg.axis()
				    .scale(x_range)
				    .orient("bottom");

				var yAxis_range = d3.svg.axis()
				    .scale(y_range)
				    .orient("left")
				    .ticks(5);

				var svg_range = d3.select(this.ui.rangeGraphDiv[0]).append("svg")
				    .attr("width", width_range + margin_range.left + margin_range.right)
				    .attr("height", height_range + margin_range.top + margin_range.bottom)
				  .append("g")
				    .attr("transform", "translate(" + margin_range.left + "," + margin_range.top + ")");

				x_range.domain(["Range"]);

				console.log(config_obj.score_range.min_score);
				y_range.domain([config_obj.score_range.min_score, config_obj.score_range.max_score]);

				var g = svg_range.append("g");
			  

			  // create the red bar
			  if(config_obj.score_range.min_score != null && config_obj.score_range.max_score != null && config_obj.score_range.benchmark1_score != null ){
			  	g.append("rect")
		  		.attr("class", "bar")
		  		.attr("x", x_range("Range"))
		  		.attr("width", x_range.rangeBand())
		  		.attr("y", y_range(config_obj.score_range.benchmark1_score ? config_obj.score_range.benchmark1_score : config_obj.score_range.benchmark2_score))
		  		.attr("fill", "#B14F51")
		  		.attr("height", y_range(config_obj.score_range.min_score) - y_range(config_obj.score_range.benchmark1_score))	
			  }
		  	

		  	// create the yellow bar
			  if(config_obj.score_range.min_score != null && config_obj.score_range.max_score != null && config_obj.score_range.benchmark2_score != null){
			  	g.append("rect")
			  		.attr("class", "bar")
			  		.attr("x", x_range("Range"))
			  		.attr("width", x_range.rangeBand())
			  		.attr("y", y_range(config_obj.score_range.benchmark2_score))
			  		.attr("fill", "#EACD46")
			  		.attr("height", y_range(config_obj.score_range.benchmark1_score != null ? config_obj.score_range.benchmark1_score : config_obj.score_range.min_score) - y_range(config_obj.score_range.benchmark2_score))
		  	}
		  	
		  	// create the green bar
			  if(config_obj.score_range.min_score != null && config_obj.score_range.max_score != null){
			  	g.append("rect")
			  		.attr("class", "bar")
			  		.attr("x", x_range("Range"))
			  		.attr("width", x_range.rangeBand())
			  		.attr("y", y_range(config_obj.score_range.max_score))
			  		.attr("fill", "#49883F")
			  		.attr("height", y_range(config_obj.score_range.benchmark2_score ? config_obj.score_range.benchmark2_score : (config_obj.score_range.benchmark1_score ? config_obj.score_range.benchmark1_score : config_obj.score_range.min_score)) - y_range(config_obj.score_range.max_score))
				}

				// show min_score text
			  if(config_obj.score_range.min_score != null){
					g.append("text")
			    	.text(config_obj.score_range.min_score)
			  		.attr("x", x_range("Range") + x_range.rangeBand()/2)
			  		.attr("y", y_range(config_obj.score_range.min_score) - 12)
			  		.attr("dy", ".71em")
			    	.attr("fill", "black")
			    	.attr("text-anchor", "middle");
				}

				// show benchmark_1 text
			  if(config_obj.score_range.benchmark1_score != null){
					g.append("text")
			    	.text(config_obj.score_range.benchmark1_score)
			  		.attr("x", x_range("Range") + x_range.rangeBand()/2)
			  		.attr("y", y_range(config_obj.score_range.benchmark1_score) - 12 )
			  		.attr("dy", ".71em")
			    	.attr("fill", "black")
			    	.attr("text-anchor", "middle");
			  }

				// show benchmark_2 text
			  if(config_obj.score_range.benchmark2_score != null){
			    g.append("text")
			    	.text(config_obj.score_range.benchmark2_score)
			  		.attr("x", x_range("Range") + x_range.rangeBand()/2)
			  		.attr("y", y_range(config_obj.score_range.benchmark2_score) - 12 )
			  		.attr("dy", ".71em")
			    	.attr("fill", "black")
			    	.attr("text-anchor", "middle");
				}

		    // show the max_score text
			  if(config_obj.score_range.max_score != null){
			   	g.append("text")
			    	.text(config_obj.score_range.max_score)
			  		.attr("x", x_range("Range") + x_range.rangeBand()/2)
			  		.attr("y", y_range(config_obj.score_range.max_score)  - 12)
			  		.attr("dy", ".71em")
			    	.attr("fill", "black")
			    	.attr("text-anchor", "middle");
				}

		    // show the x-axis
		   	svg_range.append("g")
			      .attr("class", "x axis")
			      .attr("transform", "translate(0," + height_range + ")")
			      .call(xAxis_range)
		      .append("text")
			      .attr("y", 6)
			      .attr("dy", ".71em")
			      .style("text-anchor", "end")
			}
			
		 	// CREATE THE PERFORMANCE GRAPH
		  var data = this.model.get("data");

		  if(data.length > 0){
		  	var margin = {top: 20, right: 20, bottom: 30, left: 40},
				    width = (config_obj && config_obj.width ? config_obj.width : 450) - margin.left - margin.right,
				    height = (config_obj && config_obj.height ? config_obj.height : 200) - margin.top - margin.bottom;

				var x = d3.scale.ordinal()
				    .rangeRoundBands([0, width], .1);

				var y = d3.scale.linear()
				    .range([height_range, 0]);
				    // .range([height, 0]);

				var xAxis = d3.svg.axis()
				    .scale(x)
				    .orient("bottom");

				var yAxis = d3.svg.axis()
				    .scale(y)
				    .orient("left")
				    .ticks(5);

				var svg = d3.select(this.ui.performanceGraphDiv[0]).append("svg")
				    .attr("width", width + margin.left + margin.right)
				    .attr("height", height + margin.top + margin.bottom)
				  .append("g")
				    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

				
			  x.domain(data.map(function(d) { return d.x; }));
			  if (config_obj.score_range.max_score && config_obj.score_range.min_score) {
			  	y.domain([config_obj.score_range.min_score, config_obj.score_range.max_score]);
			  }
			  else{
				  y.domain([0, d3.max(data, function(d) { return d.y; })]);
			  }

			  svg.append("g")
			      .attr("class", "x axis")
			      .attr("transform", "translate(0," + height + ")")
			      .call(xAxis)
		      .append("text")
			      .attr("y", 6)
			      .attr("dy", ".71em")
			      .style("text-anchor", "end")
			      .text(this.model.get("labels").x);

			  svg.append("g")
			      .attr("class", "y axis")
			      .call(yAxis)
			    // .append("text")
			    //   .attr("transform", "rotate(-90)")
			    //   .attr("y", 6)
			    //   .attr("dy", ".71em")
			    //   .style("text-anchor", "end")
			    //   .text(this.model.get("labels").y);

			  var bar = svg.selectAll(".bar")
			      .data(data)
			    .enter().append("g");
			    
			    bar.append("rect")
			      .attr("class", "bar")
			      .attr("x", function(d) { return x(d.x); })
			      .attr("width", x.rangeBand())
			      .attr("y", function(d) { return y(d.y); })
			      .attr("fill", function(d) { return d.color; })
			      .attr("height", function(d) { return height - y(d.y); });
					
					bar.append("text")
			    	.text(function(d){return d.y})
			      .attr("x", function(d) { return x(d.x) + x.rangeBand()/2; })
			      .attr("y", function(d) { return y(d.y) + 5; })
			      .attr("dy", ".71em")
			    	.attr("fill", "white")
			    	.attr("text-anchor", "middle");

		  }
			

		}
	});

	Scores.CompletionTableView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_Scores_CompletionTable"],		
	});	

	

});