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

		onChildviewShowClassroomView: function(){
			console.log("Row View: heard show:classroom:view");			
		}
		
	});	


	Classrooms.ClassroomView = Marionette.ItemView.extend({
		tagName: "div",
		className: "",
		template: JST["teacher/templates/TeacherApp_Classrooms_Classroom"],

		ui:{
			createButton: "[ui-create-button]",
			cancelButton: "[ui-cancel-button]",
			classroomForm: "[ui-classroom-form]",
			nameInput: "[ui-name-input]",
			descriptionInput: "[ui-description-input]",
			classroomCodeInput: "[ui-classroom-code-input]",

		},

		events:{
			"submit @ui.classroomForm": "saveClassroom",
			"click @ui.cancelButton": "showClassroomsSummary"
		},

		triggers:{
			
		},

		saveClassroom: function(e){
			e.preventDefault();
			this.setModelAttributes();

			TeacherAccount.TeacherApp.Classrooms.Controller.saveClassroom(this);
		},

		setModelAttributes: function(){
			console.log(this);
			this.model.attributes.name = this.ui.nameInput.val();
			this.model.attributes.description = this.ui.descriptionInput.val();
			this.model.attributes.classroom_code = this.ui.classroomCodeInput.val();			
			console.log(this);
		},

		showErrors: function(errors){
			this.model.attributes.errors = errors;
			console.log(this.model);
			this.render();
		},

		showClassroomsSummary: function(){
			TeacherAccount.navigate("classrooms")
			TeacherAccount.TeacherApp.Classrooms.Controller.showClassroomOverviews();
		}




	})

});