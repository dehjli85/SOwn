//= require student/student

StudentAccount.module("StudentApp.Classroom", function(Classroom, StudentAccount, Backbone, Marionette, $, _){
	
	Classroom.HeaderView = Marionette.ItemView.extend({				
		template: JST["student/templates/StudentApp_Classroom_Header"],			
		className: "col-md-12",		
		tagName: "div",		
	
	});

	Classroom.LayoutView = Marionette.LayoutView.extend({
		template: JST["student/templates/StudentApp_Classroom_Layout"],		
		className: "col-md-12",
		regions:{
			headerRegion: "#classroom_header_region",
			mainRegion: '#classroom_main_region',
			modalRegion: '#classroom_modal_region',
			scoresRegion: '#classroom_scores_region',
			tagsRegion: '#classroom_tags_region',
			searchRegion: '#classroom_search_region'
		},

		ui:{
			modalRegion: "#classroom_modal_region"
		},

		onChildviewActivitiesLayoutShowTrackModal: function(view){
			this.ui.modalRegion.modal("show");
			StudentAccount.StudentApp.Classroom.Controller.openTrackModal(this,view.model.get("classroom_activity_pairing_id"));
		},

		onChildviewActivitiesLayoutShowGoalModal: function(view){
			this.ui.modalRegion.modal("show");
			StudentAccount.StudentApp.Classroom.Controller.openGoalModal(this, view.model.get("classroom_activity_pairing_id"));
		},

		onChildviewClassroomLayoutSavePerformance: function(trackModalView, scoresTableCompositeView){
			Classroom.Controller.savePerformance(this, trackModalView, scoresTableCompositeView);
		},

		onChildviewClassroomLayoutSaveAllPerformances: function(trackModalView, scoresTableCompositeView){
			console.log("classroomlayoutview: save all performances");
			Classroom.Controller.saveAllPerformances(this, trackModalView, scoresTableCompositeView);
		},

		onChildviewActivitiesLayoutShowSeeAllModal: function(view){
			this.ui.modalRegion.modal("show");
			StudentAccount.StudentApp.Classroom.Controller.openSeeAllModal(this,view.model.get("classroom_activity_pairing_id"));
		},

		onChildviewActivitiesLayoutShowActivityDetailsModal: function(view){
			this.ui.modalRegion.modal("show");
			StudentAccount.StudentApp.Classroom.Controller.openActivityDetailsModal(this, view.model.get("classroom_activity_pairing_id"));
		},

		onChildviewFilterSearchClassroomView: function(view){
			this.model.attributes.searchTerm = view.ui.searchInput.val();
			StudentAccount.StudentApp.Classroom.Controller.showClassroomScores(this, this.model.attributes.classroomId, view.ui.searchInput.val(), null);
		},

		onChildviewFilterTagClassroomView: function(view){

			if(view.ui.label.hasClass("selected_tag")){
				view.ui.label.removeClass("selected_tag");
				
				var index = $.inArray(view.model.attributes.id, this.model.attributes.tags);
				this.model.attributes.tags.splice(index, 1);

			}
			else{

				view.ui.label.addClass("selected_tag");
				this.model.attributes.tags.push(view.model.attributes.id);

			}

			StudentAccount.StudentApp.Classroom.Controller.showClassroomScores(this, this.model.attributes.classroomId, null, this.model.attributes.tags);
		},

		onChildviewSaveActivityGoal: function(setGoalModalView){
			StudentAccount.StudentApp.Classroom.Controller.saveNewActivityGoal(this, setGoalModalView.ui.goalForm);
		}


		
	});

	Classroom.ActivityView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_Activity"],			
		tagName: "tr",		
		initialize: function(options){

		},

		ui:{
			trackButton: "[ui-track-button]",
			nameLink: "[ui-name-a]",
			setGoalLink: "[ui-set-goal-link]",
			enterScoreLink: "[ui-enter-score-link]"
		},

		triggers:{
			"click @ui.trackButton": "activities:layout:show:track:modal",
			"click .enter-score-link": "activities:layout:show:track:modal",
			"click @ui.seeAllButton": "activities:layout:show:see:all:modal",
			"click @ui.nameLink": "activities:layout:show:activity:details:modal",
			"click @ui.setGoalLink": "activities:layout:show:goal:modal",
		}
		
	});

	Classroom.ActivitiesCompositeView = Marionette.CompositeView.extend({
		template: JST["student/templates/StudentApp_Classroom_ActivitiesComposite"],			
		tagName: "div",
		className: "col-sm-12",
		childView: Classroom.ActivityView,
		childViewContainer: "tbody",
		childViewOptions: function(model, index){

		}
		
	});

	Classroom.TrackModalView = Marionette.LayoutView.extend({
		template: JST ["student/templates/StudentApp_Classroom_TrackModal"],
		className: "modal-dialog modal-dialog_wide",

		regions:{
			graphRegion: "[ui-bar-graph-region]",
			scoresRegion: "[ui-scores-region]"
		},

		ui:{
			performanceForm: "[ui-performance-form]",
			dateInput: "[ui-date-input]"
		},

		initialize: function(options){
			this.$el.attr("role","document");
		},

		onShow: function(){

			this.showBarGraphRegion(this);

			if(this.model.get("activity").activity_type == 'scored'){
				this.showScoresRegion(this);
			}
			else if(this.model.get("activity").activity_type == 'completion'){
				this.showCompletionRegion(this);
			}

			// deal with if HTML5 date input not supported
      if (!Modernizr.inputtypes.date) {
      	// If not native HTML5 support, fallback to jQuery datePicker
        $(this.ui.dateInput).datepicker({
            // Consistent format with the HTML5 picker
                dateFormat : 'yy-mm-dd'
            },
            // Localization
            $.datepicker.regional['en']
        );
      }
		},

		onRender: function(){
			if(this.model.get("showScoreBar")){
				this.showScoreBar();
			}
		},

		showBarGraphRegion: function(trackModalView){

			if (this.model.get("activity").activity_type == 'scored'){

	   		var modelData = [];
	   		var index = 1;

	   		var dates = [];
	   		var counter = 1;
				this.model.get("performances").map(function(item){

	   			//set color of bars
					var color = "#49883F";
					if(item.performance_color == "danger-sown")
						color = "#B14F51";
					else if(item.performance_color == 'warning-sown')
						color = "#EACD46";

					//set data depending on activity type
					var next = moment(item.performance_date).format("MM/DD");
					if($.inArray(moment(item.performance_date).format("MM/DD"), dates) >=  0){
						counter++;
						next += " (" + counter + ")";
					}
					else{
						counter = 1;
					}
					dates.push(moment(item.performance_date).format("MM/DD"));

					modelData.push({x: next, y: item.scored_performance, color: color})
					index++;

				});	 

				var modelLabels = {x: "Attempt", y: "Score"};

				var scoreRangeObj = {min_score: this.model.get("activity").min_score, benchmark1_score: this.model.get("activity").benchmark1_score, benchmark2_score: this.model.get("activity").benchmark2_score, max_score: this.model.get("activity").max_score};

				var model = new Backbone.Model({data:modelData, labels: modelLabels, score_range: scoreRangeObj});

				var barGraphView = new StudentAccount.StudentApp.Classroom.PerformanceBarGraphView({model: model});
				trackModalView.graphRegion.show(barGraphView);
			}
		 
		},

		showScoresRegion: function(trackModalView){
			console.log("hello");
			var collection = new Backbone.Collection(this.model.get("performances"));
			var scoresTableCompositeView = new Classroom.ScoresTableCompositeView({model: this.model, collection: collection});
			trackModalView.scoresRegion.show(scoresTableCompositeView);

		},

		showCompletionRegion: function(trackModalView){
			var collection = new Backbone.Collection(this.model.get("performances"));
			var completionTableCompositeView = new Classroom.CompletionTableCompositeView({model: this.model, collection: collection});
			trackModalView.scoresRegion.show(completionTableCompositeView);

		},

		onChildviewSavePerformance: function(scoresTableCompositeView){
			this.triggerMethod("classroom:layout:save:performance", scoresTableCompositeView);
		},

		onChildviewSaveAllPerformances: function(scoresTableCompositeView){
			this.triggerMethod("classroom:layout:save:all:performances", scoresTableCompositeView);
		}

	});

	Classroom.SeeAllModalView = Marionette.LayoutView.extend({
		template: JST ["student/templates/StudentApp_Classroom_SeeAllModal"],
		className: "modal-dialog",
		
		regions:{
			graphRegion: "[ui-bar-graph-region]"
		},

		initialize: function(options){
			this.$el.attr("role","document");			
		},


	});

	Classroom.GoalModalView = Marionette.LayoutView.extend({
		template: JST ["student/templates/StudentApp_Classroom_GoalModal"],
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
			errorMessageDiv: "[ui-error-message-div]"
		},

		events:{
			"click @ui.addReflectionLink": "revealReflectionDiv",
			"click @ui.scoreGoalLink": "revealScoreGoalInput",
			"click @ui.goalDateLink": "revealGoalDateInput",
			"click @ui.saveButton": "saveActivityGoal"
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

		validate: function(){


			// for completion activity: date is in right format
			if(this.model.get("activity").activity_type == 'completion'){
				
				if(!moment(this.ui.goalDateInput.val()).isValid()){	
					this.ui.errorMessageDiv.html("The date you chose is not valid.  Please choose a valid date")
					return false;
				}
				
			}

			// for scores activity: score isn't empty, date is in valid format if provided
			if(this.model.get("activity").activity_type == 'scored'){
				
				var dateValid = moment(this.ui.goalDateInput.val(), "YYYY-MM-DD").isValid() ;

				if(this.ui.scoreGoalInput.val() == ""){
					this.ui.errorMessageDiv.html("You must enter in a score for your goal");
					return false;
				}
				else if(!$.isNumeric(this.ui.scoreGoalInput.val())){
					this.ui.errorMessageDiv.html("The score you entered is not a number...");
					return false;
				}
				else if((this.model.get("activity").min_score != null && this.ui.scoreGoalInput.val() < this.model.get("activity").min_score) || (this.model.get("activity").max_score != null && this.ui.scoreGoalInput.val() > this.model.get("activity").max_score) ){
					this.ui.errorMessageDiv.html("Your score must be between " + this.model.get("activity").min_score + " and " + this.model.get("activity").max_score );
					return false;
				}
				else if(this.ui.goalDateInput.val() != "" && !dateValid){
					this.ui.errorMessageDiv.html("The date you chose is not valid.  Please choose a valid date")
					return false;
				}


			}

			return true;

		},

		saveActivityGoal: function(){
			if(this.validate()){
				this.triggerMethod("save:activity:goal");
			}
		},

		onShow:function(){
			// deal with if HTML5 date input not supported
      if (!Modernizr.inputtypes.date) {
      	// If not native HTML5 support, fallback to jQuery datePicker
        $(this.ui.goalDateInput).datepicker({
            // Consistent format with the HTML5 picker
                dateFormat : 'yy-mm-dd'
            },
            // Localization
            $.datepicker.regional['en']
        );
      }
		}


	});

/*
 * This view requires a model with the following attributes:
 *	=> data: json object with fields (arrays) "x", "y", and "color"
 *  => labels: json object with fields (strings) "x" and "y"
 */
Classroom.PerformanceBarGraphView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_PerformanceBarGraph"],
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
				if(height_range == null){
					y = d3.scale.linear()
				    .range([height, 0]);
				}

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
			  if (config_obj.score_range.max_score != null && config_obj.score_range.min_score != null) {
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

	Classroom.CompletionTableView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_CompletionTable"],		
	});

	Classroom.ScoresTableItemView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_ScoresTableItem"],		
		tagName: "tr",

		ui:{
			deleteButton: "[ui-delete-button]"
		},

		triggers:{
			"click @ui.deleteButton": "delete:performance"
		},

		initialize: function(options){
			this.model.set("activity", options.activity);
			this.model.set("editOrShow", options.editOrShow);
			this.model.set("errors", options.errors);
		},

		onShow: function(){
			this.toggleView(this.model.get("editOrShow"));
		},

		toggleView: function(editOrShow){
			if(editOrShow == 'show'){
				$('.ui-edit').css("display", "none");
				$('.ui-show').css("display", "");
			}
			else if(editOrShow == 'edit'){
				$('.ui-show').css("display", "none");
				$('.ui-edit').css("display", "");
			}
		}
	});

	Classroom.ScoresTableCompositeView = Marionette.CompositeView.extend({
		template: JST["student/templates/StudentApp_Classroom_ScoresTableComposite"],		
		tagName: "div",
		className: "",
		
		childView: Classroom.ScoresTableItemView,
		childViewContainer: "[ui-performance-table-tbody]",

		ui:{
			performanceTableForm: "[ui-performance-table-form]",
			performanceTableTbody: "[ui-performance-table-tbody]",
			addPerformanceButton: "[ui-add-performance-button]",
			editButton: "[ui-edit-button]",
			saveButton: "[ui-save-button]",
			cancelButton: "[ui-cancel-button]",
			newPerformanceRow: "[ui-new-performance-row]",
			hiddenTable: "[ui-hidden-table]"
		},

		triggers: {
			"click @ui.addPerformanceButton": "save:performance"
		},

		events:{
			"click @ui.editButton": "showEditView",
			"click @ui.saveButton": "saveAllPerformances",
			"click @ui.cancelButton": "cancelEdit"
		},

		initialize: function(){
			if(this.model.get("editOrShow") == null){
				this.model.set("editOrShow", "show");
			}
			if(this.model.get("student_performance_errors") == null){
				this.model.set("student_performance_errors", null);
			}
		},

		onRender: function(){
			this.toggleEditSaveButton();
		},
		
		childViewOptions: function(model, index){
			return {
				activity: this.model.get("activity"),
				editOrShow: this.model.get("editOrShow"),
				errors: this.model.get("errors")[model.get("id")] ? this.model.get("errors")[model.get("id")] : null
			};
		},

		showNewPerformanceRow: function(){
			this.ui.newPerformanceRow.remove();
			this.ui.newPerformanceRow.appendTo(this.ui.performanceTableTbody);
		},

		hideNewPerformanceRow: function(){
			this.ui.newPerformanceRow.remove();
			this.ui.newPerformanceRow.appendTo(this.ui.hiddenTable);
		},

		toggleEditSaveButton: function(){
			if(this.model.get("editOrShow") == 'show'){
				this.ui.editButton.css("display", "");
				this.ui.saveButton.css("display", "none");
				this.ui.cancelButton.css("display", "none");
				this.showNewPerformanceRow();
			}
			else if(this.model.get("editOrShow") == 'edit'){
				this.ui.editButton.css("display", "none");
				this.ui.saveButton.css("display", "");
				this.ui.cancelButton.css("display", "");
				this.hideNewPerformanceRow();
			}
		},

		showEditView: function(e){
			e.preventDefault();
			this.model.set("editOrShow", "edit");
			this.render();
		},

		saveAllPerformances: function(e){
			e.preventDefault();
			this.triggerMethod("save:all:performances");
		},

		cancelEdit: function(e){
			e.preventDefault();
			this.model.set("editOrShow", "show");
			this.render();			
		},

		onChildviewDeletePerformance: function(scoresTableItemView){
			this.collection.remove(scoresTableItemView.model);
		}

	});
	

	Classroom.CompletionTableItemView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_CompletionTableItem"],		
		tagName: "tr",

		ui:{
			deleteButton: "[ui-delete-button]"
		},

		triggers:{
			"click @ui.deleteButton": "delete:performance"
		},

		initialize: function(options){
			this.model.set("activity", options.activity);
			this.model.set("editOrShow", options.editOrShow);
			this.model.set("errors", options.errors);
		},

		onShow: function(){
			this.toggleView(this.model.get("editOrShow"));
			console.log(this.model);
		},

		toggleView: function(editOrShow){
			if(editOrShow == 'show'){
				$('.ui-edit').css("display", "none");
				$('.ui-show').css("display", "");
			}
			else if(editOrShow == 'edit'){
				$('.ui-show').css("display", "none");
				$('.ui-edit').css("display", "");
			}
		}
	});
	
	
	Classroom.CompletionTableCompositeView = Marionette.CompositeView.extend({
		template: JST["student/templates/StudentApp_Classroom_CompletionTableComposite"],		
		tagName: "div",
		className: "",
		
		childView: Classroom.CompletionTableItemView,
		childViewContainer: "[ui-performance-table-tbody]",

		ui:{
			performanceTableForm: "[ui-performance-table-form]",
			performanceTableTbody: "[ui-performance-table-tbody]",
			addPerformanceButton: "[ui-add-performance-button]",
			editButton: "[ui-edit-button]",
			saveButton: "[ui-save-button]",
			cancelButton: "[ui-cancel-button]",
			newPerformanceRow: "[ui-new-performance-row]",
			hiddenTable: "[ui-hidden-table]"
		},

		triggers: {
			"click @ui.addPerformanceButton": "save:performance"
		},

		events:{
			"click @ui.editButton": "showEditView",
			"click @ui.saveButton": "saveAllPerformances",
			"click @ui.cancelButton": "cancelEdit"
		},

		initialize: function(){
			if(this.model.get("editOrShow") == null){
				this.model.set("editOrShow", "show");
			}
			if(this.model.get("student_performance_errors") == null){
				this.model.set("student_performance_errors", null);
			}
		},

		onRender: function(){
			this.toggleEditSaveButton();
		},
		
		childViewOptions: function(model, index){
			return {
				activity: this.model.get("activity"),
				editOrShow: this.model.get("editOrShow"),
				errors: this.model.get("errors")[model.get("id")] ? this.model.get("errors")[model.get("id")] : null
			};
		},
		
		showNewPerformanceRow: function(){
			this.ui.newPerformanceRow.remove();
			this.ui.newPerformanceRow.appendTo(this.ui.performanceTableTbody);
		},

		hideNewPerformanceRow: function(){
			this.ui.newPerformanceRow.remove();
			this.ui.newPerformanceRow.appendTo(this.ui.hiddenTable);
		},

		toggleEditSaveButton: function(){
			if(this.model.get("editOrShow") == 'show'){
				this.ui.editButton.css("display", "");
				this.ui.saveButton.css("display", "none");
				this.ui.cancelButton.css("display", "none");
				this.showNewPerformanceRow();
			}
			else if(this.model.get("editOrShow") == 'edit'){
				this.ui.editButton.css("display", "none");
				this.ui.saveButton.css("display", "");
				this.ui.cancelButton.css("display", "");
				this.hideNewPerformanceRow();
			}
		},

		showEditView: function(e){
			e.preventDefault();
			this.model.set("editOrShow", "edit");
			this.render();
		},

		saveAllPerformances: function(e){
			e.preventDefault();
			this.triggerMethod("save:all:performances");
		},

		cancelEdit: function(e){
			e.preventDefault();
			this.model.set("editOrShow", "show");
			this.render();			
		},

		onChildviewDeletePerformance: function(completionsTableItemView){
			this.collection.remove(completionsTableItemView.model);
		}

	});



	


	Classroom.ActivityDetailsModalView = Marionette.ItemView.extend({
		template: JST ["student/templates/StudentApp_Classroom_ActivityDetailsModal"],
		className: "modal-dialog",

		ui:{

		},

		triggers:{

		},

		initialize: function(options){
			this.$el.attr("role","document");			

		},


	});

	Classroom.SearchBarView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_SearchBar"],			
		className: "col-sm-5",
		triggers: {
			"submit [ui-search-form]":"filter:search:classroom:view"
		},
		ui:{
			searchInput: "[ui-search-input]"
		}
	});

	Classroom.TagView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_Tag"],			
		tagName: "li",

		ui: {
			label: "a"
		},

		triggers: {
			"click a":"filter:tag:classroom:view"			
		}
		
	});

	Classroom.TagCollectionView = Marionette.CollectionView.extend({
		childView: Classroom.TagView,
		tagName: "ul",
		className: "list-inline col-sm-12",		
	});



	

});