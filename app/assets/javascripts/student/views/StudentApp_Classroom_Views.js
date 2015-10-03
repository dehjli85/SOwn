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

		onChildviewSavePerformance: function(view){
			StudentAccount.StudentApp.Classroom.Controller.savePerformance(this, view, view.ui.performanceForm);
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

		
	});

	Classroom.ActivityView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_Activity"],			
		tagName: "tr",		
		initialize: function(options){

		},

		ui:{
			trackButton: "[ui-track-button]",
			seeAllButton: "[ui-see-all-a]",
			nameLink: "[ui-name-a]"
		},

		triggers:{
			"click @ui.trackButton": "activities:layout:show:track:modal",
			"click @ui.seeAllButton": "activities:layout:show:see:all:modal",
			"click @ui.nameLink": "activities:layout:show:activity:details:modal"
		}
		
	});

	Classroom.ActivitiesCompositeView = Marionette.CompositeView.extend({
		template: JST["student/templates/StudentApp_Classroom_ActivitiesComposite"],			
		tagName: "div",
		className: "col-md-12",
		childView: Classroom.ActivityView,
		childViewContainer: "tbody",
		childViewOptions: function(model, index){

		}
		
	});

	Classroom.TrackModalView = Marionette.ItemView.extend({
		template: JST ["student/templates/StudentApp_Classroom_TrackModal"],
		className: "modal-dialog",

		ui:{
			saveButton: "[ui-save-button]",
			performanceForm: "[ui-performance-form]"
		},

		triggers:{
			"click @ui.saveButton": "save:performance"
		},

		initialize: function(options){
			this.$el.attr("role","document");

			this.setShowScoreBar();
		},

		onShow: function(){
			if(this.model.get("showScoreBar")){
				this.showScoreBar();
			}
		},

		onRender: function(){
			if(this.model.get("showScoreBar")){
				this.showScoreBar();
			}
		},

		showScoreBar: function(){

			var dataset, colours;
			//setup the data first
			if(this.model.get("activity").benchmark1_score != null && this.model.get("activity").benchmark2_score != null){
				dataset = [
					{
		        data: [{
		            month: '',
		            count: this.model.get("activity").benchmark1_score - this.model.get("activity").min_score
		        }],
		        name: 'Series #1'
		    	}, 
		    	{
		        data: [{
		            month: '',
		            count: this.model.get("activity").benchmark2_score - this.model.get("activity").benchmark1_score
		        }],
		        name: 'Series #2'
		    	}, 
		    	{
		        data: [{
		            month: '',
		            count: this.model.get("activity").max_score - this.model.get("activity").benchmark2_score
		        }],
		        name: 'Series #2'
		    	}
		    ];

		    colours = ["#D56464","#ECD76C","#6BBD49"];

			}else{
				var benchmark = this.model.get("activity").benchmark1_score != null ? this.model.get("activity").benchmark1_score : this.model.get("activity").benchmark2_score;
				dataset = [
					{
		        data: [{
		            month: '',
		            count: benchmark - this.model.get("activity").min_score
		        }],
		        name: 'Series #1'
		    	}, 
		    	{
		        data: [{
		            month: '',
		            count: this.model.get("activity").max_score - benchmark
		        }],
		        name: 'Series #2'
		    	}
		    ];

		    colours = [null ,"#6BBD49"];
		    if(this.model.get("activity").benchmark1_score == null){
		    	colours[0] = "#ECD76C";
		    }else{
		    	colours[0] = "#D56464";
		    }
			}

			var margins = {
				    top: 12,
				    left: 20,
				    right: 24,
				    bottom: 24
				},				
				width = 400 - margins.left - margins.right ,
				    height = 100 - margins.top - margins.bottom,				    
				    series = dataset.map(function (d) {
				        return d.name;
				    }),
				    dataset = dataset.map(function (d) {
				        return d.data.map(function (o, i) {
				            // Structure it so that your numeric
				            // axis (the stacked amount) is y
				            return {
				                y: o.count,
				                x: o.month
				            };
				        });
				    }),
				    stack = d3.layout.stack();

				stack(dataset);

				var dataset = dataset.map(function (group) {
				    return group.map(function (d) {
				        // Invert the x and y values, and y0 becomes x0
				        return {
				            x: d.y,
				            y: d.x,
				            x0: d.y0
				        };
				    });
				}),
				    svg = d3.select('.scoreBarDiv')
				        .append('svg')
				        .attr('width', width + margins.left + margins.right)
				        .attr('height', height + margins.top + margins.bottom)
				        .append('g')
				        .attr('transform', 'translate(' + margins.left + ',' + margins.top + ')'),
				    xMax = d3.max(dataset, function (group) {
				        return d3.max(group, function (d) {
				            return d.x + d.x0;
				        });
				    }),
				    xScale = d3.scale.linear()
				        .domain([0, xMax])
				        .range([0, width]),
				    months = dataset[0].map(function (d) {
				        return d.y;
				    }),
				    _ = console.log(months),
				    yScale = d3.scale.ordinal()
				        .domain(months)
				        .rangeRoundBands([0, height], .1),
				    xAxis = d3.svg.axis()
				        .scale(xScale)
				        .orient('bottom'),
				    yAxis = d3.svg.axis()
				        .scale(yScale)
				        .orient('left'),
				    
				    groups = svg.selectAll('g')
				        .data(dataset)
				        .enter()
				        .append('g')
				        .style('fill', function (d, i) {
				        return colours[i];
				    }),
				    rects = groups.selectAll('rect')
				        .data(function (d) {
				        return d;
				    })
				        .enter()
				        .append('rect')
				        .attr('x', function (d) {
				        return xScale(d.x0);
				    })
				        .attr('y', function (d, i) {
				        return yScale(d.y);
				    })
				        .attr('height', function (d) {
				        return yScale.rangeBand();
				    })
				        .attr('width', function (d) {
				        return xScale(d.x);
				    })
				        .on('mouseover', function (d) {
				        var xPos = parseFloat(d3.select(this).attr('x')) + parseFloat(d3.select(this).attr('width')) / 2 + width / 2;
				        // var xPos = width / 2;

				        var yPos = parseFloat(d3.select(this).attr('y')) + yScale.rangeBand() / 2;
				        // console.log(xPos);
				        // console.log(d3.select(this));
				        d3.select('#tooltip')
				            .style('left', xPos + 'px')
				            .style('top', 75 + 'px')
				            .select('#value')
				            .text(d.x0 + " - " + (d.x0+d.x));
				            // .text("asdfadsfasd");


				        d3.select('#tooltip').classed('hidden', false);
				    })
				        .on('mouseout', function () {
				        d3.select('#tooltip').classed('hidden', true);
				    })

				    svg.append('g')
				        .attr('class', 'axis')
				        .attr('transform', 'translate(0,' + height + ')')
				        .call(xAxis);

						svg.append('g')
						    .attr('class', 'axis')
						    .call(yAxis);
	
		},

		setShowScoreBar: function(){
			if(this.model.get("activity").activity_type == "scored" 
				&& this.model.get("activity").max_score != null
				&& this.model.get("activity").min_score != null
				&& (this.model.get("activity").benchmark1_score != null || this.model.get("activity").benchmark2_score != null)){

				this.model.attributes.showScoreBar = true;

			}
			else{
				this.model.attributes.showScoreBar = false;
			}
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

	/*
 * This view requires a model with the following attributes:
 *	=> data: json object with fields (arrays) "x" and "y" 
 *  => labels: json object with fields (strings) "x" and "y"
 */
Classroom.BarGraphView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_BarGraph"],
		ui:{
			barGraphDiv: "[ui-bar-graph-div]"
		},

		onShow: function(){
			this.showBarGraph();
		},

		/*
		 * height
		 * width
		 * color array
		 */
		showBarGraph: function(config_obj){

			var data = this.model.get("data");

			var margin = {top: 20, right: 20, bottom: 30, left: 40},
			    width = (config_obj && config_obj.height ? config_obj.height : 450) - margin.left - margin.right,
			    height = (config_obj && config_obj.height ? config_obj.height : 200) - margin.top - margin.bottom;

			var x = d3.scale.ordinal()
			    .rangeRoundBands([0, width], .1);

			var y = d3.scale.linear()
			    .range([height, 0]);

			var xAxis = d3.svg.axis()
			    .scale(x)
			    .orient("bottom");

			var yAxis = d3.svg.axis()
			    .scale(y)
			    .orient("left")
			    .ticks(5);

			var svg = d3.select(this.ui.barGraphDiv[0]).append("svg")
			    .attr("width", width + margin.left + margin.right)
			    .attr("height", height + margin.top + margin.bottom)
			  .append("g")
			    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

			
		  x.domain(data.map(function(d) { return d.x; }));
		  y.domain([0, d3.max(data, function(d) { return d.y; })]);

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
		    .append("text")
		      .attr("transform", "rotate(-90)")
		      .attr("y", 6)
		      .attr("dy", ".71em")
		      .style("text-anchor", "end")
		      .text(this.model.get("labels").y);

		  var bar = svg.selectAll(".bar")
		      .data(data)
		    .enter().append("g")
		    
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
	});

	Classroom.CompletionTableView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_CompletionTable"],		
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