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
			"click @ui.deleteLink": "open:delete:activity:modal",
		},

		events:{
			"click @ui.editLink": "openEditActivityDialog"

		},


		openEditActivityDialog:function(e){
	  	
	  	e.preventDefault();

	  	var activityId = $(e.target).attr("name").replace("activity_","");
	  	this.model.set("activityId", activityId);

	  	this.triggerMethod("open:edit:activity:dialog");
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
			"submit [ui-search-form]":"activities:index:filter:search:term",
			"click @ui.createActivityButton": "classrooms:open:new:activity:dialog"
		},

		ui: {
			searchInput: "[ui-search-input]",
			searchButton: "[ui-search-button]",
			createActivityButton: "[ui-create-activity-button]"
		},

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

		onChildviewClassroomsOpenNewActivityDialog: function(view){
			TeacherAccount.TeacherApp.Activities.Controller.openEditActivityDialog(this);
		},

		onChildviewOpenEditActivityDialog: function(view){
			TeacherAccount.TeacherApp.Activities.Controller.openEditActivityDialog(this, view.model.get("activityId"));
		},

		onChildviewSaveActivity: function(view){
			view.setModelAttributes();
			if(view.model.get("activity_status") == "New"){
				TeacherAccount.TeacherApp.Activities.Controller.saveNewActivity(this, view);
			}
			else if(view.model.get("activity_status") == "Edit"){
				TeacherAccount.TeacherApp.Activities.Controller.updateActivity(this, view);
			}
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
	    this.model.set("index",options.index);
	  }

	});

	Activities.EditActivityTagsCompositeView = Marionette.CompositeView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_EditActivityTagsCompositeView"],
		tagName: "div",
		childView: Activities.EditActivityTagView,
		childViewContainer: "ul#tagDisplayList",

		ui:{
			addTagsButton: "[ui-add-tags-button]", 
			tagInput: "[ui-tag-input]",
			tagInputDiv: "[ui-tag-input-div]",
		},

		events:{
			"click @ui.addTagsButton": "addTag",
		},

		childViewOptions: function(model, index){			
			return {
				index: index,
			}
		},

		onShow: function(){
			$('[ui-tag-input-div] .typeahead').typeahead({
			  hint: true,
			  highlight: true,
			  minLength: 1
			},
			{
			  name: 'teacher_tags',
			  source: this.substringMatcher(this.model.get("teacher_tags"))
			});
			

			$('.twitter-typeahead').css("display", "block");

		},

		onChildviewRemoveTagFromCollection: function(view){
			this.collection.remove(view.model);
		},

		addTag: function(e){
			if(e != null){
				e.preventDefault();
			}

			if(this.ui.tagInput.val().trim() != ""){
				var tagModel = {name: this.ui.tagInput.val().replace(/ /g,""), index: this.model.get("tagCount")};
				this.collection.push(tagModel);
				this.model.set("tagCount", this.model.get("tagCount") +1);
			}
			this.ui.tagInput.val("");
		},

		copyActivityTags: function(activity_tags){
			for(var i = 0; i < activity_tags.length; i++){
				this.ui.tagInput.val(activity_tags[i].name);
				this.addTag();
			}
		},


		substringMatcher: function(strs) {
		  return function findMatches(q, cb) {
		    var matches, substringRegex;

		    // an array that will be populated with substring matches
		    matches = [];

		    // regex used to determine if a string contains the substring `q`
		    substrRegex = new RegExp(q, 'i');

		    // iterate through the pool of strings and for any string that
		    // contains the substring `q`, add it to the `matches` array
		    $.each(strs, function(i, str) {
		      if (substrRegex.test(str)) {
		        matches.push(str);
		      }
		    });

		    cb(matches);
		  }
		},

		
	});

	Activities.EditActivityLevelView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_EditActivityLevel"],
		tagName: "tr",

		ui:{
			deleteButton: "[ui-delete-button]",
			nameInput: "[ui-name-input]",
			abbreviationInput: "[ui-abbreviation-input]"
		},

		events:{
			"click @ui.deleteButton": "removeLevel"
		},

		removeLevel: function(e){
			e.preventDefault();
			this.triggerMethod("remove:level:from:collection");
		},

		initialize : function (options) {
	    this.model.set("index",options.index);
	    this.model.set("editOrShow", options.editOrShow);
			this.model.set("errors", options.errors);	    
	  },

	  onShow: function(){
			this.toggleView(this.model.get("editOrShow"));
		},

		toggleView: function(editOrShow){
			if(editOrShow == 'show'){
				$('.ui-edit').css("display", "none");
				$('.ui-show').css("display", "");
			}
			else if(editOrShow == 'edit'){
				$('.ui-show').css("display", "none");
				$('.ui-edit').css("display", "");
			}
		}

	});

	Activities.EditActivityLevelsCompositeView = Marionette.CompositeView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_EditActivityLevelsCompositeView"],
		tagName: "div",
		childView: Activities.EditActivityLevelView,
		childViewContainer: "[ui-level-table-tbody]",

		ui:{
			addLevelButton: "[ui-add-level-button]", 
			levelNameInput: "[ui-level-name-input]",
			levelAbbreviationInput: "[ui-level-abbreviation-input]",
			levelTableForm: "[ui-level-table-form]",
			levelTableTbody: "[ui-level-table-tbody]",
			addLevelButton: "[ui-add-level-button]",
			editButton: "[ui-edit-button]",
			levelsDoneButton: "[ui-levels-done-button]",
			newLevelRow: "[ui-new-level-row]",
			hiddenTable: "[ui-hidden-table]"
		},

		triggers:{
		},

		events:{
			"click @ui.editButton": "showEditView",
			"click @ui.levelsDoneButton": "saveAllLevels",
			"click @ui.cancelButton": "cancelEdit",
			"click @ui.addLevelButton": "addLevel",
		},

		initialize: function(){
			if(this.model.get("editOrShow") == null){
				this.model.set("editOrShow", "show");
			}

			if(this.model.get("newLevelIndex") == null){
				this.model.set("newLevelIndex", 0);
			}
		},

		childViewOptions: function(model, index){		
			return {
				editOrShow: this.model.get("editOrShow"),
				errors: this.model.get("errors")[model.get("id")] ? this.model.get("errors")[model.get("id")] : null,				
				index: index,
			}
		},

		onRender: function(){
			console.log(this.model);
			this.toggleEditSaveButton();
		},

		showNewLevelRow: function(){
			this.ui.newLevelRow.remove();
			this.ui.newLevelRow.appendTo(this.ui.levelTableTbody);
		},

		hideNewLevelRow: function(){
			this.ui.newLevelRow.remove();
			this.ui.newLevelRow.appendTo(this.ui.hiddenTable);
		},

		toggleEditSaveButton: function(){
			if(this.model.get("editOrShow") == 'show'){
				this.ui.editButton.css("display", "");
				this.ui.levelsDoneButton.css("display", "none");
				this.showNewLevelRow();
			}
			else if(this.model.get("editOrShow") == 'edit'){
				this.ui.editButton.css("display", "none");
				this.ui.levelsDoneButton.css("display", "");
				this.hideNewLevelRow();
			}
		},

		showEditView: function(e){
			e.preventDefault();
			this.model.set("editOrShow", "edit");
			this.triggerMethod("hide:modal:save:and:cancel:buttons");
			this.render();
		},

		addLevel: function(e){
			if(e != null){
				e.preventDefault();
			}

			if(this.ui.levelAbbreviationInput.val().trim().length > 0){
				var levelModel = new Backbone.Model({
					name: this.ui.levelNameInput.val().trim(),
					abbreviation: this.ui.levelAbbreviationInput.val().trim(),
					id: "new" + this.model.get("newLevelIndex")
				});
				this.model.set("newLevelIndex", this.model.get("newLevelIndex") + 1);
				this.collection.push(levelModel);
				this.render();	
			}
			
		},

		saveAllLevels: function(e){
			e.preventDefault();

			this.children.each(function(view){
				view.model.set("name", view.ui.nameInput.val());
				view.model.set("abbreviation", view.ui.abbreviationInput.val());
			});

			this.model.set("editOrShow", "show");
			this.render();
			this.toggleEditSaveButton();
			this.triggerMethod("show:modal:save:and:cancel:buttons");

		},

		cancelEdit: function(e){
			e.preventDefault();
			this.model.set("editOrShow", "show");
			this.render();			
		},

		showErrors: function(levelErrors){
			this.model.set("errors", levelErrors);
			this.model.set("editOrShow", "edit");
			this.render();
		},

		copyActivityLevels: function(activity_levels){
			for(var i = 0; i < activity_levels.length; i++){
				this.ui.levelNameInput.val(activity_levels[i].name);
				this.ui.levelAbbreviationInput.val(activity_levels[i].abbreviation);
				this.addLevel();
			}
		},


		onChildviewRemoveLevelFromCollection: function(view){
			this.collection.remove(view.model);
		},
		
	});


	Activities.EditActivityModalLayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_EditActivityModalLayout"],
		tagName: "div",
		className: "modal-dialog",

		regions:{
			tagsRegion: "#tags_region",
			levelsRegion: "#levels_region"
		},

		ui:{
			activityForm: "[ui-activity-form]",
			scoreRangeDiv: "[ui-score-range-div]",
			scoreRangeHeader: "[ui-score-color-tab-header]",
			optionalFieldsHeader: "[ui-optional-fields-tab-header]",
			activityTypeSelect: "[ui-activity-type-select]",
			addTagsButton: "[ui-add-tags-button]", 
			tagInput: "[ui-tag-input]",
			nameInput: "[ui-name-input]",
			descriptionInput: "[ui-description-input]",
			instructionsInput: "[ui-instructions-input]",			
			linkInput: "[ui-link-input]",
			maxScoreInput: "[ui-max-score-input]",
			minScoreInput: "[ui-min-score-input]",
			benchmark1ScoreInput: "[ui-benchmark-one-score-input]",
			benchmark2ScoreInput: "[ui-benchmark-two-score-input]",
			assignmentForm: "[ui-assignment-form]",
			saveButton: "[ui-save-button]",
			cancelButton: "[ui-cancel-button]",
			tagInputDiv: "[ui-tag-input-div]",
			copyButton: "[ui-copy-button]",
			copyInput: "[ui-copy-input]",
			levelInputs: "[ui-level-input]",
			addLevelButton: "[ui-add-level-button]"
		},

		events:{
			"change @ui.activityTypeSelect": "toggleScoreRangeDiv",
			"submit @ui.activityForm": "addTag",
			"click @ui.copyButton": "copyActivityFields"
		},

		triggers:{
			"click @ui.saveButton": "save:activity"
		},


		toggleScoreRangeDiv: function(){
			if(this.ui.activityTypeSelect.val() == 'scored'){
				this.ui.scoreRangeHeader.attr("style", "display:block");
			}
			else{
				this.ui.scoreRangeHeader.attr("style", "display:none");	
				this.ui.optionalFieldsHeader.tab('show')
			}
		},


		setModelAttributes: function(){
			this.model.set("name", this.ui.nameInput.val());
			this.model.set("description", this.ui.descriptionInput.val());
			this.model.set("instructions", this.ui.instructionsInput.val());
			this.model.set("activity_type", this.ui.activityTypeSelect.val());
			this.model.set("max_score", this.ui.maxScoreInput.val());
			this.model.set("min_score", this.ui.minScoreInput.val());
			this.model.set("benchmark1_score", this.ui.benchmark1ScoreInput.val());
			this.model.set("benchmark2_score", this.ui.benchmark2ScoreInput.val());
		},

		showErrors: function(){
			console.log(this.model);
			if(this.model.get("level_errors") != null){
				this.levelsRegion.currentView.showErrors(this.model.get("level_errors"));
			}
			if(this.model.get("tag_errors") != null && this.model.get("tag_errors").length > 0){
				this.tagsRegion.currentView.showErrors(this.model.get("tag_errors"));
			}
			if(this.model.get("tag_pairing_errors") != null && this.model.get("tag_pairing_errors").length > 0){
				this.tagsRegion.currentView.showErrors(this.model.get("tag_pairing_errors"));
			}

		},

		onShow: function(){
			var tagsModel = new Backbone.Model({teacher_tags: this.model.get("teacher_tags"), tagCount: this.model.get("tagCount")});
			var editActivityTagsCompositeView = new Activities.EditActivityTagsCompositeView({collection: this.model.get("activity_tags"), model: tagsModel});
			this.tagsRegion.show(editActivityTagsCompositeView);


			var levelsModel = new Backbone.Model({levelCount: this.model.get("levelCount"), activity_id: this.model.get("id"), errors: {}});
			var editActivityLevelsCompositeView = new Activities.EditActivityLevelsCompositeView({collection: this.model.get("activity_levels"), model: levelsModel});
			this.levelsRegion.show(editActivityLevelsCompositeView);
			
			$('[ui-copy-input]').typeahead({
			  hint: true,
			  highlight: true,
			  minLength: 1
			},
			{
			  name: 'activity_names',
			  source: this.substringMatcher(this.model.get("activity_names"))
			});

			$('.twitter-typeahead').css("display", "block");

		},

		substringMatcher: function(strs) {
		  return function findMatches(q, cb) {
		    var matches, substringRegex;

		    // an array that will be populated with substring matches
		    matches = [];

		    // regex used to determine if a string contains the substring `q`
		    substrRegex = new RegExp(q, 'i');

		    // iterate through the pool of strings and for any string that
		    // contains the substring `q`, add it to the `matches` array
		    $.each(strs, function(i, str) {
		      if (substrRegex.test(str)) {
		        matches.push(str);
		      }
		    });

		    cb(matches);
		  }
		},

		copyActivityFields: function(e){
			e.preventDefault();
			//find the right activity
			var activity = null;
			for(var i = 0; i < this.model.get("activities").length; i++){
				if(this.model.get("activities")[i].name == this.ui.copyInput.val()){
					activity = this.model.get("activities")[i];
				}
			}


			//populate the input fields
			if(activity != null){
				this.ui.activityTypeSelect.val(activity.activity_type);
				this.toggleScoreRangeDiv();
				this.ui.nameInput.val(activity.name + " copy");
				this.ui.descriptionInput.val(activity.description);
				this.ui.instructionsInput.val(activity.instructions);
				this.ui.linkInput.val(activity.link);
				this.ui.maxScoreInput.val(activity.max_score)
				this.ui.minScoreInput.val(activity.min_score)
				this.ui.benchmark1ScoreInput.val(activity.benchmark1_score);
				this.ui.benchmark2ScoreInput.val(activity.benchmark2_score);

				this.levelsRegion.currentView.copyActivityLevels(activity.activity_levels);
				this.tagsRegion.currentView.copyActivityTags(activity.tags);
				this.model.set("tagCount", 0);


			}

		},

		onChildviewHideModalSaveAndCancelButtons: function(){
			this.ui.saveButton.css("display", "none")
			this.ui.cancelButton.css("display", "none");
		},

		onChildviewShowModalSaveAndCancelButtons: function(){
			this.ui.saveButton.css("display", "")
			this.ui.cancelButton.css("display", "");
		},

		

	});

	Activities.ActivityAssignView = Marionette.ItemView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_ActivityAssign"],
		tagName: "tr",

		ui:{
			assignedCheckbox: "[ui-assign-checkbox]",
			dueDateInput: "[ui-due-date-input]",
			hiddenCheckbox: "[ui-hide-checkbox]",
			archivedCheckbox: "[ui-archive-checkbox]",
		},

		events:{
			"click @ui.assignedCheckbox": "toggleExtraFields"
		},

		toggleExtraFields: function(e){
			if(this.ui.assignedCheckbox.prop("checked")){
				this.ui.dueDateInput.removeAttr("disabled");
				this.ui.hiddenCheckbox.removeAttr("disabled");
				this.ui.archivedCheckbox.removeAttr("disabled");
			}else{
				this.ui.dueDateInput.attr("disabled", "");
				this.ui.hiddenCheckbox.attr("disabled", "");
				this.ui.archivedCheckbox.attr("disabled", "");
			}
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

	Activities.ClassroomAssignActivitiesModalCompositeView = Marionette.CompositeView.extend({
		template: JST["teacher/templates/Activities/TeacherApp_Activities_ClassroomAssignActivitiesModalComposite"],
		tagName: "div",
		className: "modal-dialog",
		childView: Activities.ActivityAssignView,
		childViewContainer: "tbody",	

		initialize: function(){
			this.sort();
			
		},

		onShow: function(){
			$(".ion-help-circled").tooltip();
		},



		sort: function(){
			this.collection.comparator = function(a, b){
				if (a.get("classroom_activity_pairing") && b.get("classroom_activity_pairing")){
					return a.get("classroom_activity_pairing").sort_order > b.get("classroom_activity_pairing").sort_order ? 1 : -1
				}
				if(!a.get("classroom_activity_pairing") && !b.get("classroom_activity_pairing")){
					return a.get("name") < b.get("name") ? -1 : 1;
				}
				if(a.get("classroom_activity_pairing"))
					return -1;
				if(b.get("classroom_activity_pairing")){
					return 1;
				}

			}

			this.collection.sort();
		},

		ui:{
			assignmentForm: "[ui-assignment-form]",
			saveButton: "[ui-save-button]"
		},

		triggers:{
			"click @ui.saveButton": "save:classroom:activity:assignments"
		}
	});

	

});

