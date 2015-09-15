Admin.module("AdminApp.Metrics", function(Metrics, Admin, Backbone, Marionette, $, _){

	Metrics.BarGraph = Marionette.ItemView.extend({
		template: JST["admin/templates/AdminApp_Metrics_BarGraph"],
		ui:{
			barGraphDiv: "[ui-bar-graph-div]"
		},

		showBarGraph: function(){

			// var w = 500;
			// var h = 200;

			// var dataset = [ 5, 10, 13, 19, 21, 25, 22, 18, 15, 13,
   //      11, 12, 15, 20, 18, 17, 16, 18, 23, 25 ];

   //  	var barPadding = 1;

			// var svg = d3.select("[ui-bar-graph-div]")
   //      .append("svg")
   //      .attr("width", w)
   //      .attr("height", h);

   //    svg.selectAll("rect")
			// 	.data(dataset)
			// 	.enter()
			// 	.append("rect")
			// 	.attr("x", function(d, i) {
		 //    	return i * (w / dataset.length);
			// 	})
			// 	.attr("y", function(d) {
			//     return h - d*4;  //Height minus data value
			// 	})
			// 	.attr("width", w / dataset.length - barPadding)
			// 	.attr("height", function(d) {
			//     return d*4;  // <-- Times four!
			// 	})
			// 	.attr("fill", "teal");

			var data = this.model.get("data");
			var transformedData = [];
			years = Object.keys(data);

			for(var i = 0; i < years.length; i++){
				weeks = Object.keys(data[years[i]]);

				for(var j = 0; j < weeks.length; j++){
					console.log(data[years[i]][weeks[j]]);
					transformedData.push({year: years[i], week: weeks[j], count: data[years[i]][weeks[j]] })
				}

			}

			console.log(transformedData);

			var margin = {top: 20, right: 20, bottom: 30, left: 40},
			    width = 500 - margin.left - margin.right,
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

			var svg = d3.select("[ui-bar-graph-div]").append("svg")
			    .attr("width", width + margin.left + margin.right)
			    .attr("height", height + margin.top + margin.bottom)
			  .append("g")
			    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

			
		  x.domain(transformedData.map(function(d) { return d.week; }));
		  y.domain([0, d3.max(transformedData, function(d) { return d.count; })]);

		  svg.append("g")
		      .attr("class", "x axis")
		      .attr("transform", "translate(0," + height + ")")
		      .call(xAxis);

		  svg.append("g")
		      .attr("class", "y axis")
		      .call(yAxis)
		    .append("text")
		      .attr("transform", "rotate(-90)")
		      .attr("y", 6)
		      .attr("dy", ".71em")
		      .style("text-anchor", "end")
		      .text("Student Users");

		  svg.selectAll(".bar")
		      .data(transformedData)
		    .enter().append("rect")
		      .attr("class", "bar")
		      .attr("x", function(d) { return x(d.week); })
		      .attr("width", x.rangeBand())
		      .attr("y", function(d) { return y(d.count); })
		      .attr("height", function(d) { return height - y(d.count); });

			function type(d) {
			  d.frequency = +d.frequency;
			  return d;
			}

		}
	});

});