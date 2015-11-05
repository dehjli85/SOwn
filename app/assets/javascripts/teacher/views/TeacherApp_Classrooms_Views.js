//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classrooms", function(Classrooms, TeacherAccount, Backbone, Marionette, $, _){
	
	Classrooms.ClassroomWidgetView = Marionette.ItemView.extend({				
		template: JST["teacher/templates/TeacherApp_Classrooms_ClassroomWidget"],			
		className: "col-xs-6 col-sm-4 col-md-4 col-lg-3 classroom-widget",
		model: Classrooms.Models.ClassroomWidgetModel,

		triggers: {
			"click .placeholder.thumbnail":"teacherapp:start:classroom:app:scores"			
		},

		ui:{
			d3Div: "[ui-dthree-div]"
		},

		onShow: function(){
			
			//set up d3 object
			var d3Div = d3.select(this.ui.d3Div[0]);					

			//create radial image
			var rp = radialProgress(this.ui.d3Div[0])
	      .label("% activities proficient")
	      .diameter(150)
	      .value(this.model.get('percent_proficient'))
	      .render();
    
    	//set color of image
			var color;
			if(this.model.get('percent_proficient') < 30){
				color = '#b00d08';				
			}				
      else if (this.model.get('percent_proficient') < 70)
        color = '#f0a417'
      else
        color ='#1d871b'

			this.ui.d3Div.find($(".arc")).attr("style","fill:" + color);            
		},

		onDomRefresh: function(){
			this.triggerMethod("widget:rendered");
		}
			
	});

	

	Classrooms.ClassroomWidgetRowView = Marionette.CompositeView.extend({
		tagName: "div",
		className: "col-md-12 placeholders",
		template: JST["teacher/templates/TeacherApp_Classrooms_ClassroomWidgetRow"],							
		childView: Classrooms.ClassroomWidgetView,
		childViewContainer: "#widget-container-div",

		ui:{
			addClassDiv: '[ui-add-class-div]',
			widgetContainerDiv: "#widget-container-div"
		},

		triggers:{
			"click @ui.addClassDiv": "show:new:class:form"
		},

		onChildviewShowClassroomView: function(){
			console.log("Row View: heard show:classroom:view");			
		},

		onShow: function(){
			this.ui.widgetContainerDiv.append(this.ui.addClassDiv);

			// setTimeout(function(){
				
			// }, 1000)

		},

		onChildviewWidgetRendered: function(){
			var thumbnails = $('.thumbnail');
			var max = 0;
			thumbnails.map(function(i){
				if ($(thumbnails[i]).height() > max){
					max = $(thumbnails[i]).height();
				}
			}); 

			thumbnails.map(function(i){
				$(thumbnails[i]).height(max);
			}); 
		},

		



		
	});	


	

});