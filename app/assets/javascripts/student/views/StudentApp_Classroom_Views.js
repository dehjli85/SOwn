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
		}
		
	});

	Classroom.ActivityView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Classroom_Activity"],			
		tagName: "tr",		
		initialize: function(options){

		},

		ui:{
			trackButton: "[ui-track-button]"
		},

		triggers:{
			"click @ui.trackButton": "activities:composite:show:track:modal"
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
		},


	})



	

});