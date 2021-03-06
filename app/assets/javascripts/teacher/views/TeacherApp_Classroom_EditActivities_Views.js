//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.EditActivities", function(EditActivities, TeacherAccount, Backbone, Marionette, $, _){

	EditActivities.ActivityOptionView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_EditActivities_ActivityOption"],			
		tagName: "option",
		className: "",
		triggers: {
			
		},
		ui:{
			
		},

		initialize : function (options) {
	    this.model.attributes.parentActivity = options.activity;	    
	    this.$el.attr("value",this.model.attributes.id);
	    if(this.model.attributes.id == this.model.attributes.parentActivity.id)
	    	this.$el.attr("selected","selected");
	  }

	});

	EditActivities.ActivityAssignmentView = Marionette.CompositeView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_EditActivities_ActivityAssignment"],			
		className: "",
		childView: EditActivities.ActivityOptionView,
		childViewContainer: "select",		
		
		triggers: {
			"change @ui.select": "edit:activities:rerender:activity:assignment:view"
		},
		
		ui:{
			assignedButton: "[ui-assigned-button]",
			select: "[ui-select]"
		},

		childViewOptions: function(model, index){			
			return {activity: this.model.attributes.activity}
		},

		onRender: function(){
			var options = {
		    onText: "Yes",
		    onColor: 'primary',    
		    offText: "No",
		    animate: true,        
		  };

		  // console.log($(this.ui.assignedButton));
		  var assigned_button = $(this.ui.assignedButton).bootstrapSwitch(options);

		  assigned_button.bootstrapSwitch('state', this.model.attributes.pairing);
		  
  		
  		var obj = this;
  		assigned_button.on('switchChange.bootstrapSwitch', function(event, state) {
		    this.value = assigned_button.bootstrapSwitch('state');		    
		    obj.triggerMethod("edit:activities:toggle:verification:view");
		  });
		  


		  
		}

	});

	EditActivities.VerificationsView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_EditActivities_Verification"],			
		tagName: "tr",
		triggers: {
			
		},

		ui: {
			checkBox: "[ui-checkbox]"
		}
		
	});

	EditActivities.AssignmentOptionsCompositeView = Marionette.CompositeView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_EditActivities_AssignmentOptionsComposite"],
		tagName: "div",
		className: "",
		childView: EditActivities.VerificationsView,
		childViewContainer: "tbody",

		ui: {
			verificationsForm: "[ui-verifications-form]",
			allA: "[ui-all-a]",
			noneA: "[ui-none-a]",
			randomA: "[ui-random-a]",
			hiddenButton: "[ui-hidden-button]",	
			dueDateInput: "[ui-due-date-input]"		
		},

		triggers:{
			"click @ui.allA": "checkAllVerifications",
			"click @ui.noneA": "uncheckAllVerifications",
			"click @ui.randomA": "checkRandomVerifications",
		},

		onCheckAllVerifications: function(){
			this.children.each(function (childview) {
	      childview.ui.checkBox.prop("checked", true);
	    });
			
		},

		onUncheckAllVerifications: function(){
			this.children.each(function (childview) {
	      childview.ui.checkBox.prop("checked", false);
	    });
			
		},

		onCheckRandomVerifications: function(){
			this.children.each(function (childview) {
				childview.ui.checkBox.prop("checked", false);
				if(Math.random() < .2)
	      	childview.ui.checkBox.prop("checked", true);
	    });
			
		},

		onRender: function(){

			var options = {
		    onText: "Yes",
		    onColor: 'primary',    
		    offText: "No",
		    animate: true,        
		  };

		  var hidden_button = $(this.ui.hiddenButton).bootstrapSwitch(options);
		  if(this.model.attributes.pairing){
			  hidden_button.bootstrapSwitch('state', this.model.attributes.pairing.hidden);
		  }

  		var obj = this;

  		hidden_button.on('switchChange.bootstrapSwitch', function(event, state) {
		    this.value = hidden_button.bootstrapSwitch('state');		    
		  });
		},

		onShow: function(){
			// deal with if HTML5 date input not supported
      if (!Modernizr.inputtypes.date) {
      	// If not native HTML5 support, fallback to jQuery datePicker
        $(this.ui.dueDateInput).datepicker({
            // Consistent format with the HTML5 picker
                dateFormat : 'yy-mm-dd'
            },
            // Localization
            $.datepicker.regional['en']
        );
      }	
		}

		
		
	});

	EditActivities.AlertView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_EditActivities_Alert"],
		tagName: "div",
		className: "alert center",

		initialize: function(options){			
	    this.$el.addClass(this.model.attributes.alertClass);
	    //this.$el.attr("style", "margin-bottom:0px");
		}
	})

	
	EditActivities.LayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/Classroom/TeacherApp_Classroom_EditActivities_Layout"],			
		regions:{			
			activityAssignmentRegion: "#activity_assignment_region",
			optionsRegion: "#options_region",
			alertRegion: "#alert_region"
		},

		triggers:{
			"click @ui.saveButton": "saveAssignmentAndVerifications"
		},

		ui:{
			saveButton:"[ui-save-button]"
		},

		onChildviewEditActivitiesToggleVerificationView: function(view){

			if(view.ui.assignedButton.val() == "true"){					
				TeacherAccount.TeacherApp.Classroom.EditActivities.Controller.showClassroomEditActivitiesAssignmentOptionsView(this,this.model.attributes.classroomId,view.model.attributes.activity.id)
			}else{
				this.optionsRegion.empty();
			}
		},

		onChildviewEditActivitiesRerenderActivityAssignmentView: function(view){
			//re-render both regions with the new activity			
			TeacherAccount.TeacherApp.Classroom.EditActivities.Controller.renderActivityAssignmentView(this, this.model.attributes.classroomId, view.ui.select.val());
		},

		onSaveAssignmentAndVerifications: function(){

			//clear out the alert
			this.alertRegion.empty();

			//set up the verifications data to be saved
			var verificationsForm = null;
			var hiddenInput = null
			if(this.optionsRegion.currentView){
				verificationsForm = this.optionsRegion.currentView.ui.verificationsForm;
				hiddenInput = this.optionsRegion.currentView.ui.hiddenButton.val();
			}

			TeacherAccount.TeacherApp.Classroom.EditActivities.Controller.saveActivityAssignmentAndOptions(
				this,
				this.model.attributes.classroomId, 
				this.activityAssignmentRegion.currentView.model.attributes.activity.id,
				this.activityAssignmentRegion.currentView.ui.assignedButton.val(),
				verificationsForm
			);

		}




	})

	

	

});