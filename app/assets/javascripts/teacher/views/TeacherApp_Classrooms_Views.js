//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classrooms", function(Classrooms, TeacherAccount, Backbone, Marionette, $, _){
	
	Classrooms.ClassroomWidgetView = Marionette.ItemView.extend({				
		template: JST["teacher/templates/TeacherApp_Classrooms_ClassroomWidget"],			
		className: "col-xs-6 col-sm-3 placeholder",
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
		}
			
	});

	

	Classrooms.ClassroomWidgetRowView = Marionette.CompositeView.extend({
		tagName: "div",
		className: "row placeholders",
		template: JST["teacher/templates/TeacherApp_Classrooms_ClassroomWidgetRow"],							
		childView: Classrooms.ClassroomWidgetView,
		childViewContainer: "#widget-container-div",

		ui:{
			addClassDiv: '[ui-add-class-div]'
		},

		triggers:{
			"click @ui.addClassDiv": "show:new:class:form"
		},

		onChildviewShowClassroomView: function(){
			console.log("Row View: heard show:classroom:view");			
		}
		
	});	


	

});