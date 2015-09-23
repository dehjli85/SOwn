Admin.module("AdminApp.Metrics", function(Metrics, Admin, Backbone, Marionette, $, _){

	Metrics.BarGraph = Marionette.ItemView.extend({
		template: JST["admin/templates/AdminApp_Metrics_BarGraph"],
		ui:{
			barGraphDiv: "[ui-bar-graph-div]"
		},

		showBarGraph: function(){


			var data = this.model.get("data");

			var margin = {top: 20, right: 20, bottom: 30, left: 40},
			    width = 450 - margin.left - margin.right,
			    height = 200 - margin.top - margin.bottom;

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
		      .attr("height", function(d) { return height - y(d.y); });
				
				bar.append("text")
		    	.text(function(d){return d.y})
		      .attr("x", function(d) { return x(d.x) + x.rangeBand()/2; })
		      .attr("y", function(d) { return y(d.y) + 5; })
		      .attr("dy", ".71em")
		    	.attr("fill", "white")
		    	.attr("text-anchor", "middle");
			    	// .attr("x", function(d) { return x(d.x); })
				  // .attr("y", function(d) { return y(d.y); });

			

		}
	});

	Metrics.MetricsLayoutView = Marionette.LayoutView.extend({
		template: JST["admin/templates/AdminApp_MetricsLayout"],
		className: "row",
		regions: {
			vizOne: "[ui-viz-one]",
			vizTwo: "[ui-viz-two]",
			vizThree: "[ui-viz-three]",
			vizFour: "[ui-viz-four]"	
		},
	});

	Metrics.NumberPanelView = Marionette.ItemView.extend({
		template: JST["admin/templates/AdminApp_NumberPanel"],
		className: "panel panel-tile text-center br-a br-grey"
	});

	Metrics.UserMetricsLayoutView = Marionette.LayoutView.extend({
		template: JST["admin/templates/AdminApp_UserMetricsLayout"],
			className: "row",
			regions: {
				vizOne: "[ui-viz-one]",
				vizTwo: "[ui-viz-two]",
				vizThree: "[ui-viz-three]",
				vizFour: "[ui-viz-four]"	
			},
	});

});