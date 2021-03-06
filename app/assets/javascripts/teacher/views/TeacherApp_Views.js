//= require teacher/teacher

TeacherAccount.module("TeacherApp", function(TeacherApp, TeacherAccount, Backbone, Marionette, $, _){
	
	TeacherApp.HeaderView = Marionette.ItemView.extend({				
		template: JST["teacher/templates/TeacherApp_Header"],
		tagName: "nav",
		className: "navbar navbar-inverse navbar-fixed-top navbar-inverse_theme",

		ui: {
			switchAccountLink: "[ui-switch-account-link]",
			settingsLink: "[ui-settings-link]",
			homeLink: "[ui-home-link]",
			activitiesLink: "[ui-activities-link]"
		},

		events:{
			"click .ui-classroom-link": "showClassroom",
			"click @ui.homeLink": "showClassrooms",
			"click @ui.activitiesLink": "showActivities",
			"click .ui-social": "socialLinkClick"
		},

		triggers:{
			"click @ui.switchAccountLink": "show:student:view",
			"click @ui.settingsLink": "start:settings:app",
		},

		onShowStudentView: function(){
			TeacherApp.Main.Controller.showStudentView();
   		ga('send', 'event', 'teacher_app', 'switch_account', '');

		},

		showClassroom: function(e){
			e.preventDefault();
   		
   		ga('send', 'event', 'teacher_app', 'header_show_classroom', '');

			TeacherAccount.TeacherApp.Main.Controller.startClassroomApp($(e.target).attr("id").replace("classroom_",""), "scores");
		},

		showClassrooms: function(e){

   		ga('send', 'event', 'teacher_app', 'header_show_overviews', '');

			e.preventDefault();
			TeacherAccount.TeacherApp.Classrooms.Controller.showClassroomOverviews();
		},

		showActivities: function(e){
			e.preventDefault();

   		ga('send', 'event', 'teacher_app', 'header_show_activities_index', '');

			TeacherAccount.TeacherApp.Main.Controller.startActivitiesApp("index");
		},

		socialLinkClick: function(e){
  		ga('send', 'event', 'public_pages', 'social_link_click', $(e.target).attr("name"));
		}
			
	});

	TeacherApp.LeftNavView = Marionette.ItemView.extend({				
		template: JST["teacher/templates/TeacherApp_LeftNav"],
		tagName: "div",
		className: "col-sm-3 col-md-2 sidebar",

		events: {
			"click li" : "makeNavActive",
			"click @ui.classroomsToggleArrow": "toggleClassrooms",
			"click .ui-classroom-link": "showClassroom"
		},

		triggers:{
			"click @ui.navActivities": "start:activities:app",
			"click @ui.navStudents": "start:students:app",
		},

		ui:{
			navClassroom: "[ui-nav-classroom]",
			navActivities: "[ui-nav-activities]",
			navStudents: "[ui-nav-students]",
			classroomSubUl: "[ui-classroom-sub-ul]",
			classroomsToggleArrow: "[ui-classrooms-toggle-arrow]"
		},

		toggleClassrooms: function(e){
			e.preventDefault();

			if(this.ui.classroomsToggleArrow.hasClass("ion-arrow-left-b")){
				this.openClassroomSubmenu();
			}
			else if(this.ui.classroomsToggleArrow.hasClass("ion-arrow-down-b")){
				this.closeClassroomSubmenu();
			}

		},

		openClassroomSubmenu: function(classroomId){
			this.ui.classroomsToggleArrow.removeClass("ion-arrow-left-b");
			this.ui.classroomsToggleArrow.addClass("ion-arrow-down-b");
			this.ui.classroomSubUl.attr("style", "display:block");

			if(classroomId != null){
				$('.ui-classroom-link').removeClass("nav_active");
				$('#classroom_' + classroomId).addClass("nav_active");
			}
		},

		closeClassroomSubmenu: function(classroomId){
			this.ui.classroomsToggleArrow.removeClass("ion-arrow-down-b");
			this.ui.classroomsToggleArrow.addClass("ion-arrow-left-b");
			this.ui.classroomSubUl.attr("style", "display:none");

			if(classroomId != null){
				$('.ui-classroom-link').removeClass("nav_active");
				$('#classroom_' + classroomId).addClass("nav_active");
			}
		},

		showClassroom: function(e){
			e.preventDefault();
			TeacherAccount.TeacherApp.Main.Controller.startClassroomApp($(e.target).attr("id").replace("classroom_",""), "scores");
		},

		makeNavActive: function(e){
			
			if(!($(e.target).attr("data-target") == "#comingSoonModal")){
				$('li').removeClass("nav_active");
				$(e.target).parent().addClass("nav_active");	
			}
			
		}

		
	});

	TeacherApp.LayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Layout"],
		el:"#teacher_account_region",
		regions:{
			headerRegion: "#header_region",
			leftNavRegion: "#left_nav_region",
			mainRegion: "#main_region",
			alertRegion: "#alert_region",
			modalRegion: "#modal_region"
		},

		ui:{
			modalRegion: "#modal_region"
		},


		onChildviewTeacherappStartClassroomAppScores: function(view){

			TeacherAccount.TeacherApp.Main.Controller.startClassroomApp(view.model.id, 'scores');

		},

		onChildviewStartActivitiesApp: function(view){
			
			TeacherAccount.TeacherApp.Main.Controller.startActivitiesApp("index");
		},

		onChildviewShowNewClassForm: function(view){			

			TeacherAccount.TeacherApp.Main.Controller.showClassroomNew(this);

		},

		onChildviewStartSettingsApp: function(view){

			TeacherAccount.TeacherApp.Main.Controller.startSettingsApp();

		},

		onChildviewStartStudentsApp: function(view){

			TeacherAccount.TeacherApp.Main.Controller.startStudentsApp("index");
		},

		onChildviewSaveClassroom: function(classroomView){
			TeacherAccount.TeacherApp.Main.Controller.saveClassroom(classroomView, this);			
		},

	});

	TeacherApp.AlertView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Alert"],
		className: "alert center teacher_app_alert",

		initialize: function(){
			this.$el.addClass(this.model.attributes.alertClass);
		}
	});

	TeacherApp.ClassroomView = Marionette.ItemView.extend({
		tagName: "div",
		className: "modal-dialog",
		template: JST["teacher/templates/TeacherApp_Classroom"],

		ui:{
			createButton: "[ui-create-button]",
			saveButton: "[ui-save-button]",
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

		onShow: function(){
		  $('[data-toggle="tooltip"]').tooltip();
		},

		saveClassroom: function(e){
			e.preventDefault();
			this.setModelAttributes();
			this.triggerMethod("save:classroom");
		},

		setModelAttributes: function(){
			this.model.attributes.name = this.ui.nameInput.val();
			this.model.attributes.description = this.ui.descriptionInput.val();
			this.model.attributes.classroom_code = this.ui.classroomCodeInput.val();			
		},

		showErrors: function(errors){
			this.model.attributes.errors = errors;
			this.render();
		},

		showClassroomsSummary: function(){
			TeacherAccount.navigate("classrooms")
			TeacherAccount.TeacherApp.Classrooms.Controller.showClassroomOverviews();
		}




	});

	TeacherApp.TagView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Tag"],			
		tagName: "li",

		ui: {
			label: "a"
		},

		triggers: {
			"click a":"filter:tag:classroom:scores:view"			
		}
		
	});

	TeacherApp.TagCollectionView = Marionette.CollectionView.extend({
		childView: TeacherApp.TagView,
		tagName: "ul",
		className: "list-inline col-sm-12",		
	});

	

});