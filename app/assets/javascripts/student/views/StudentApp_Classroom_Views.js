//= require student/student

StudentAccount.module("StudentApp.Classroom", function(Classroom, StudentAccount, Backbone, Marionette, $, _){
	
	Classroom.HeaderView = Marionette.ItemView.extend({				
		template: JST["student/templates/StudentApp_Classroom_Header"],					
		tagName: "div",		

		triggers: {
			"click @ui.scoresLink": "classroom:show:scores",
			"click @ui.editDataLink": "classroom:show:edit:scores"
		},

		events:{
			"click a": "makeTabActive"
		},

		ui:{
			scoresLink: "[ui-scores-a]",			
			editDataLink: "[ui-edit-data-a]",
			lis: "li"
		},

		makeTabActive: function(e){
			this.ui.lis.removeClass("active");			
			$(e.target).parent().addClass("active");
			
		}

		
			
	});

	Classroom.LayoutView = Marionette.LayoutView.extend({
		template: JST["student/templates/StudentApp_Classroom_Layout"],			
		regions:{
			headerRegion: "#classroom_header_region",
			mainRegion: '#classroom_main_region',
			modalRegion: '#classroom_modal_region'
		},

		ui:{
			modalRegion: "#classroom_modal_region"
		},

		onChildviewActivitiesCompositeShowTrackModal: function(view){
			this.ui.modalRegion.modal("show");
			StudentAccount.StudentApp.Classroom.Controller.openTrackModal(this,view.model.get("classroom_activity_pairing_id"));
		},

		onChildviewSavePerformance: function(view){
			StudentAccount.StudentApp.Classroom.Controller.savePerformance(this, view, view.ui.performanceForm);
		},

		onChildviewActivitiesCompositeShowSeeAllModal: function(view){
			this.ui.modalRegion.modal("show");
			StudentAccount.StudentApp.Classroom.Controller.openSeeAllModal(this,view.model.get("classroom_activity_pairing_id"));
		}
		
	});

	Classroom.ActivityView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_Activity"],			
		tagName: "tr",		
		initialize: function(options){

		},

		ui:{
			trackButton: "[ui-track-button]",
			seeAllButton: "[ui-see-all-a]"
		},

		triggers:{
			"click @ui.trackButton": "activities:composite:show:track:modal",
			"click @ui.seeAllButton": "activities:composite:show:see:all:modal"
		}
		
	});

	Classroom.ActivitiesCompositeView = Marionette.CompositeView.extend({
		template: JST["student/templates/StudentApp_Classroom_ActivitiesComposite"],			
		tagName: "div",
		className: "classroom-tab-content",
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

	Classroom.SeeAllModalView = Marionette.ItemView.extend({
		template: JST ["student/templates/StudentApp_Classroom_SeeAllModal"],
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

			this.setShowLineGraph();
		},

		setShowLineGraph: function(){
			if(this.model.get("activity").activity_type == "scored"){
				this.model.attributes.showLineGraph = true;
			}
			else{
				this.model.attributes.showLineGraph = false;
			}
		},

		onShow: function(){
			if(this.model.get("showLineGraph")){
				this.showLineGraph();
			}
		},

		

		showLineGraph: function(){

			var margin = {top: 30, right: 20, bottom: 30, left: 50},
			    width = 500 - margin.left - margin.right,
			    height = 270 - margin.top - margin.bottom;

			// Parse the date / time
			// var parseDate = d3.time.format("%d-%b-%y").parse;
			var parseDate = d3.time.format("%Y-%m-%d %H:%M:%S").parse;

			// Set the ranges
			// var x = d3.time.scale().range([0, width]);
			var x = d3.scale.linear().range([0, width]);

			var y = d3.scale.linear().range([height, 0]);

			// Define the axes
			var xAxis = d3.svg.axis().scale(x)
			    .orient("bottom").ticks(5);

			var yAxis = d3.svg.axis().scale(y)
			    .orient("left").ticks(5);

			// Define the line
			var valueline = d3.svg.line()
			    // .x(function(d) { return x(d.performance_date); })
			    .x(function(d) { return x(d.attemptNumber); })
			    .y(function(d) { return y(d.scored_performance); });
			    
			// Adds the svg canvas
			var svg = d3.select('#lineGraphDiv')
			    .append("svg")
			        .attr("width", width + margin.left + margin.right)
			        .attr("height", height + margin.top + margin.bottom)
			    .append("g")
			        .attr("transform", 
			              "translate(" + margin.left + "," + margin.top + ")");

			// Get the data
			data = this.model.attributes.performances;
			
			// data.forEach(function(d){
			// 	d.performance_date = parseDate(d.performance_date);
			// });

			for(var i = 0; i< data.length; i++){
				data[i].attemptNumber = i;
			}

	    // x.domain(d3.extent(data, function(d) { return d.performance_date; }));
	    x.domain(d3.extent(data, function(d) { return d.attemptNumber; }));
	    y.domain([0, d3.max(data, function(d) { return d.scored_performance; })]);

	    // Add the valueline path.
	    svg.append("path")
	        .attr("class", "line line_graph_path")
	        .attr("d", valueline(data));

	    // Add the scatterplot
	    svg.selectAll("dot")
	        .data(data)
	      .enter().append("circle")
	        .attr("r", 3.5)
	        // .attr("cx", function(d) { return x(d.performance_date); })
	        .attr("cx", function(d) { return x(d.attemptNumber); })	        
	        .attr("cy", function(d) { return y(d.scored_performance); });

	    // Add the X Axis
	    svg.append("g")
	        .attr("class", "x axis line_graph_axis")
	        .attr("transform", "translate(0," + height + ")")
	        .call(xAxis);

	    // Add the Y Axis
	    svg.append("g")
	        .attr("class", "y axis line_graph_axis")
	        .call(yAxis);

		}

	});



	

});