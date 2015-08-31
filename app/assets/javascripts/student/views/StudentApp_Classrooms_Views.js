//= require student/student

StudentAccount.module("StudentApp.Classrooms", function(Classrooms, StudentAccount, Backbone, Marionette, $, _){
	
	Classrooms.ClassroomWidgetView = Marionette.ItemView.extend({				
		template: JST["student/templates/StudentApp_Classrooms_ClassroomWidget"],			
		className: "col-xs-6 col-sm-4 col-md-4 col-lg-3 placeholder",
		triggers: {
			"click .placeholder.thumbnail":"show:classroom:scores"			
		},

		ui:{
			d3Div: "[ui-dthree-div]",
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
		className: "col-md-12 placeholders",
		template: JST["student/templates/StudentApp_Classrooms_ClassroomWidgetRow"],							
		childView: Classrooms.ClassroomWidgetView,
		childViewContainer: "#widget-container-div",

		ui:{
			addClassDiv: '[ui-add-class-div]',
			widgetContainerDiv: "#widget-container-div"
		},

		triggers:{
			"click @ui.addClassDiv": "classrooms:layout:show:join:class:modal"
		},

		onShow: function(){
			this.ui.widgetContainerDiv.append(this.ui.addClassDiv);
		}


		
	});	

	Classrooms.ClassroomsLayoutView = Marionette.LayoutView.extend({
		tagName: "div",
		className: "col-md-12",
		template: JST["student/templates/StudentApp_Classrooms_Layout"],

		regions:{
			mainRegion: "#classrooms_main_region",
			modalRegion: "#classrooms_modal_region"
		},

		ui:{
			modalRegion: "#classrooms_modal_region"
		},

		onChildviewClassroomsLayoutShowJoinClassModal: function(view){
			StudentAccount.StudentApp.Classrooms.Controller.showJoinClassModal(this);
		},

		onChildviewJoinClassroom: function(view){
			StudentAccount.StudentApp.Classrooms.Controller.joinClassroom(this, view);
		},

		onChildviewShowClassroomScores: function(view){
			console.log(view.model);
			StudentAccount.StudentApp.Main.Controller.startClassroomApp(view.model.get("classroom_id"), 'scores');
		}

	});

	Classrooms.ClassroomsJoinClassModalView = Marionette.ItemView.extend({
		template: JST ["student/templates/StudentApp_Classrooms_JoinClassModal"],
		className: "modal-dialog",

		ui:{
			searchButton: "[ui-search-button]",
			joinButton: "[ui-join-button]",
			classroomForm: "[ui-classroom-form]",			
			classroomCodeInput: "[ui-classroom-code-input]"
		},

		triggers:{
			"click @ui.joinButton": "joinClassroom"
		},

		events:{
			"submit @ui.classroomForm": "searchClassroomCode",
			"click @ui.joinButton": "joinClassroom"			
		},

		initialize: function(options){
			this.$el.attr("role","document");
		},

		searchClassroomCode: function(e){
			e.preventDefault();
			StudentAccount.StudentApp.Classrooms.Controller.searchClassroomCode(this);
		},

		joinClassroom: function(e){
			e.preventDefault();
		}
	})


	

});