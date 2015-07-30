//= require teacher/teacher

TeacherAccount.module("TeacherApp.Activities.Index", function(Index, TeacherAccount, Backbone, Marionette, $, _){

	Index.ActivityView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Activities_Index_ActivityView"],
		tagName: "tr",

		events:{
			"click .tag": "filterTag"
		},

		filterTag: function(e){
			var tagId = $(e.target).attr("name");
			this.model.attributes.filterTagId = tagId;
			this.triggerMethod("activities:index:filter:tag");
		}
	});

	Index.ActivitiesCompositeView = Marionette.CompositeView.extend({
		template: JST["teacher/templates/TeacherApp_Activities_Index_ActivitiesComposite"],
		tagName: "div",
		className: "classroom-tab-content",
		childView: Index.ActivityView,
		childViewContainer: "tbody",
		ui:{
			headerActivity: "[ui-header-activity]",
			headerDescription: "[ui-header-description]",
			headerMasteryGoal: "[ui-header-mastery-goal]",
			headerActivityType: "[ui-header-activity-type]"
		},

		events:{
			"click @ui.headerActivity": "sortByName",
			"click @ui.headerDescription": "sortByDescription",
			"click @ui.headerMasteryGoal": "sortByMasteryGoal",
			"click @ui.headerActivityType": "sortByActivityType"
		},

		sortByDescription: function(){
			this.collection.comparator = "description";
			this.collection.sort();
		},

		sortByName: function(){
			this.collection.comparator = "name";
			this.collection.sort();
		},

		sortByMasteryGoal: function(){
			this.collection.comparator = "instructions";
			this.collection.sort();
		},

		sortByActivityType: function(){
			this.collection.comparator = "activity_type";
			this.collection.sort();
		}

		


	});	

	Index.HeaderView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Activities_Index_Header"],					
		triggers: {
			"submit [ui-search-form]":"activities:index:filter:search:term"
		},

		ui: {
			searchInput: "[ui-search-input]",
			searchButton: "[ui-search-button]",
			createActivityButton: "[ui-create-activity-button]"
		}
		
	});

	
	
	Index.LayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Activities_Index_Layout"],			
		regions:{			
			headerRegion: "#header_region",
			mainRegion: "#main_region"
		},

		triggers:{
		},

		ui:{
			
		},

		onChildviewActivitiesIndexFilterTag: function(view){
			var tagId = view.model.attributes.filterTagId;
			TeacherAccount.TeacherApp.Activities.Index.Controller.showIndexActivitiesCompositeView(this, tagId, null);
		},

		onChildviewActivitiesIndexFilterSearchTerm: function(view){
			var searchTerm = view.ui.searchInput.val();
			TeacherAccount.TeacherApp.Activities.Index.Controller.showIndexActivitiesCompositeView(this, null, searchTerm);
		}

	})

});