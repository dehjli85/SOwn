//= require student/student

StudentAccount.module("StudentApp", function(StudentApp, StudentAccount, Backbone, Marionette, $, _){
	
	StudentApp.HeaderView = Marionette.ItemView.extend({				
		template: JST["student/templates/StudentApp_Header"],
		tagName: "nav",
		className: "navbar navbar-inverse navbar-fixed-top navbar-inverse_theme ",

		ui: {
			switchAccountLink: "[ui-switch-account-link]",
			settingsLink: "[ui-settings-link]"
		},

		triggers:{
			"click @ui.switchAccountLink": "show:teacher:view",
			"click @ui.settingsLink": "show:student:settings"
		},

		onShowTeacherView: function(){
			StudentApp.Main.Controller.showTeacherView();
		}
			
	});

	StudentApp.LeftNavView = Marionette.ItemView.extend({				
		template: JST["student/templates/StudentApp_LeftNav"],
		tagName: "ul",
		className: "nav nav-sidebar",

		events: {
			"click li" : "makeNavActive",
			"click @ui.classroomsToggleArrow": "toggleClassrooms",
			"click .ui-classroom-link": "showClassroom"
		},

		triggers:{
			"click @ui.navActivities": "start:activities:app"
		},

		ui:{
			navClassroom: "[ui-nav-classroom]",
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
			console.log($(e.target).attr("id"));
			StudentAccount.StudentApp.Main.Controller.startClassroomApp($(e.target).attr("id").replace("classroom_",""), "scores");
		},

		makeNavActive: function(e){
			
			if(!($(e.target).attr("data-target") == "#comingSoonModal")){
				$('li').removeClass("nav_active");
				$(e.target).parent().addClass("nav_active");	
			}
			
		}

		
	});

	StudentApp.LayoutView = Marionette.LayoutView.extend({
		template: JST["student/templates/StudentApp_Layout"],
		el:"#student_account_region",
		regions:{
			headerRegion: "#header_region",
			leftNavRegion: "#left_nav_region",
			mainRegion: "#main_region",
			alertRegion: "#alert_region"
		},

		onChildviewShowClassroomScores: function(view){
			StudentAccount.StudentApp.Main.Controller.startClassroomApp(view.model.get("classroom_id"), 'scores');
		},

		onChildviewShowStudentSettings: function(view){
			StudentAccount.navigate("settings");
			StudentAccount.StudentApp.Settings.Controller.showSettingsOptions();		
		}
		
	});

	StudentApp.AlertView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Alert"],
		className: "alert center",

		initialize: function(){
			this.$el.addClass(this.model.get("alertClass"));
		}
	});

	

});