//= require teacher/teacher

TeacherAccount.module("TeacherApp.Activities", function(Activities, TeacherAccount, Backbone, Marionette, $, _){

	Activities.IndexActivityView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_IndexActivityView"],
		tagName: "tr",

		ui:{
			assignLink: "[ui-assign-link]",
			deleteLink: "[ui-delete-link]",
			editLink: "[ui-edit-link]"	
		},

		triggers:{
			"click @ui.assignLink": "open:assign:activities:modal",
			"click @ui.deleteLink": "open:delete:activity:modal"
		},

		events:{
			"click @ui.editLink": "goToEditPage",

		},

		goToEditPage: function(e){
			var activityId = $(e.target).attr("name").replace("activity_","");
			TeacherAccount.TeacherApp.Activities.Controller.showEditActivity(activityId);
		}

	});

	Activities.IndexCompositeView = Marionette.CompositeView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_IndexComposite"],
		tagName: "div",
		className: "col-md-12",
		childView: Activities.IndexActivityView,
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
		}, 

		initialize: function(){

			//TODO: THIS IS A HACK, FIND THE WAY TO GET THE COLLECTION SIZE IN A COMPOSITE VIEW AND GET RID OF THIS
			if(this.model == null){
				this.model = new Backbone.Model({});
			}
			this.model.attributes.collectionSize = this.collection.length;
		}

	});	

	Activities.IndexSearchBarView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_IndexSearchBar"],					
		className: "col-md-12",
		triggers: {
			"submit [ui-search-form]":"activities:index:filter:search:term"
		},

		ui: {
			searchInput: "[ui-search-input]",
			searchButton: "[ui-search-button]",
			createActivityButton: "[ui-create-activity-button]"
		}
		
	});

	
	
	Activities.IndexLayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_IndexLayout"],			
		className: "col-md-12",
		regions:{			
			searchBarRegion: "#search_bar_region",
			tagsRegion: "#tags_region",
			mainRegion: "#main_region",
			modalRegion: "#activities_modal_region"
		},

		triggers:{
		},

		ui:{
			modalRegion: "#activities_modal_region"
		},

		onChildviewActivitiesIndexFilterTag: function(view){
			var tagId = view.model.attributes.filterTagId;
			TeacherAccount.TeacherApp.Activities.Controller.showIndexActivitiesCompositeView(this,  null, tagId);
		},

		onChildviewActivitiesIndexFilterSearchTerm: function(view){
			var searchTerm = view.ui.searchInput.val();
			TeacherAccount.TeacherApp.Activities.Controller.showIndexActivitiesCompositeView(this, searchTerm, null);
		},

		onChildviewOpenAssignActivitiesModal: function(view){
			TeacherAccount.TeacherApp.Activities.Controller.openAssignActivitiesModal(this, view.model.get("id"));
			this.ui.modalRegion.modal("show");
		},

		onChildviewActivitiesSaveAssignments: function(view){
			TeacherAccount.TeacherApp.Activities.Controller.saveActivityAssignments(this,view.ui.assignmentForm);
			this.ui.modalRegion.modal("hide");

		},

		onChildviewOpenDeleteActivityModal: function(view){
			TeacherAccount.TeacherApp.Activities.Controller.openDeleteActivityModal(this, view.model.get("id"));
			this.ui.modalRegion.modal("show");
		},

		onChildviewDeleteActivity: function(view){
			this.ui.modalRegion.modal("hide");			
			TeacherAccount.TeacherApp.Activities.Controller.deleteActivity(this, view.ui.activityForm);

		},

		onChildviewFilterTagClassroomScoresView: function(view){

			//change the color of the tag
			if(view.ui.label.hasClass("selected_tag")){
				view.ui.label.removeClass("selected_tag");
				
				var index = $.inArray(view.model.attributes.id, this.model.attributes.tags);
				this.model.attributes.tags.splice(index, 1);

			}
			else{

				view.ui.label.addClass("selected_tag");
				this.model.attributes.tags.push(view.model.attributes.id);

			}

			TeacherAccount.TeacherApp.Activities.Controller.showIndexActivitiesCompositeView(this,  null, this.model.attributes.tags);

		}

	});

	Activities.AssignActivitiesModalView = Marionette.ItemView.extend({
		template: JST ["teacher/templates/Activities/TeacherApp_Activities_AssignActivitiesModal"],
		className: "modal-dialog",

		ui:{
			saveButton: "[ui-save-button]",
			assignmentForm: "[ui-assignment-form]"
		},

		triggers:{
			"click @ui.saveButton": "activities:save:assignments"
		},

		initialize: function(options){
			this.$el.attr("role","document");
		}
	});

	Activities.DeleteActivityModalView = Marionette.ItemView.extend({
		template: JST ["teacher/templates/Activities/TeacherApp_Activities_DeleteActivityModal"],
		className: "modal-dialog",

		ui:{
			deleteButton: "[ui-delete-button]",
			cancelButton: "[ui-cencel-button]",
			activityForm: "[ui-activity-form]"
		},

		triggers:{
			"click @ui.deleteButton": "delete:activity"
		},

		initialize: function(options){
			this.$el.attr("role","document");
		}
	})

	Activities.EditActivityTagView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_EditActivityTag"],
		tagName: "li",
		events:{
			"click span": "removeTag"
		},
		removeTag: function(){
			this.triggerMethod("remove:tag:from:collection");
		},

		initialize : function (options) {
	    this.model.attributes.index = options.index;
	  }

	});



	Activities.EditActivityCompositeView = Marionette.CompositeView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_EditActivityComposite"],
		tagName: "div",
		className: "classroom-tab-content",
		childView: Activities.EditActivityTagView,
		childViewContainer: "ul",
		ui:{
			activityForm: "[ui-activity-form]",
			scoreRangeDiv: "[ui-score-range-div]",
			activityTypeSelect: "[ui-activity-type-select]",
			addTagsButton: "[ui-add-tags-button]", 
			tagInput: "[ui-tag-input]",
			nameInput: "[ui-name-input]",
			descriptionInput: "[ui-description-input]",
			instructionsInput: "[ui-instructions-input]",			
			maxScoreInput: "[ui-max-score-input]",
			minScoreInput: "[ui-min-score-input]",
			benchmark1ScoreInput: "[ui-benchmark-one-score-input]",
			benchmark2ScoreInput: "[ui-benchmark-two-score-input]",
			saveButton: "[ui-save-button]"
		},

		events:{
			"change @ui.activityTypeSelect": "toggleScoreRangeDiv",
			"click @ui.addTagsButton": "addTag",
			"submit @ui.activityForm": "addTag",
			"click @ui.saveButton": "saveActivity"
		},

		toggleScoreRangeDiv: function(){
			console.log(this.ui.activityTypeSelect.val());
			if(this.ui.activityTypeSelect.val() == 'scored'){
				this.ui.scoreRangeDiv.attr("style", "display:block");
			}
			else{
				this.ui.scoreRangeDiv.attr("style", "display:none");	
			}
		},

		addTag: function(e){
			e.preventDefault();
			if(this.ui.tagInput.val().trim() != ""){
				var tagModel = {name: this.ui.tagInput.val().replace(/ /g,""), index: this.model.attributes.tagCount};
				this.collection.push(tagModel);
				this.model.attributes.tagCount++;
			}
			this.ui.tagInput.val("");
		},

		saveActivity: function(e){	
			e.preventDefault();
			this.setModelAttributes();

			if(this.model.attributes.activity_status == "New"){
				TeacherAccount.TeacherApp.Activities.Controller.saveNewActivity(this);	
			}
			else if(this.model.attributes.activity_status == "Edit"){
				TeacherAccount.TeacherApp.Activities.Controller.updateActivity(this);	
			}
			
		},

		setModelAttributes: function(){
			this.model.attributes.name = this.ui.nameInput.val();
			this.model.attributes.description = this.ui.descriptionInput.val();
			this.model.attributes.instructions = this.ui.instructionsInput.val();
			this.model.attributes.activity_type = this.ui.activityTypeSelect.val();
			this.model.attributes.max_score = this.ui.maxScoreInput.val();
			this.model.attributes.min_score = this.ui.minScoreInput.val();
			this.model.attributes.benchmark1_score = this.ui.benchmark1ScoreInput.val();
			this.model.attributes.benchmark2_score = this.ui.benchmark2ScoreInput.val();
		},

		showErrors: function(errors){
			this.model.attributes.errors = errors;
			this.render();

		},

		childViewOptions: function(model, index){			
			return {index: index}
		},

		onChildviewRemoveTagFromCollection: function(view){
			this.collection.remove(view.model);
		}

	});	

});