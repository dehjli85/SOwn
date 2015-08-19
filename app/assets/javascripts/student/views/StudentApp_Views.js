//= require student/student

StudentAccount.module("StudentApp", function(StudentApp, StudentAccount, Backbone, Marionette, $, _){
	
	StudentApp.HeaderView = Marionette.ItemView.extend({				
		template: JST["student/templates/StudentApp_Header"],
		tagName: "nav",
		className: "navbar navbar-inverse navbar-fixed-top",

		ui: {
			switchAccountLink: "[ui-switch-account-link]"
		},

		triggers:{
			"click @ui.switchAccountLink": "show:teacher:view",
		},

		onShowTeacherView: function(){
			StudentApp.Main.Controller.showTeacherView();
		}
			
	});

	StudentApp.LeftNavView = Marionette.ItemView.extend({				
		template: JST["student/templates/StudentApp_LeftNav"],
		tagName: "div",
		className: "col-sm-3 col-md-2 sidebar",

		events: {
			"click li" : "makeNavActive"
		},

		triggers:{
			"click @ui.navActivities": "start:activities:app"
		},

		ui:{
			navClassroom: "[ui-nav-classroom]"
			
		},

		makeNavActive: function(e){
			
			if(!($(e.target).attr("data-target") == "#comingSoonModal")){
				$('li').removeClass("active");
				$(e.target).parent().addClass("active");	
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
			console.log(view.model);
			StudentAccount.StudentApp.Main.Controller.startClassroomApp(view.model.get("classroom_id"), 'scores');
		}
		
	});

	StudentApp.AlertView = Marionette.ItemView.extend({
		template: JST["student/templates/StudentApp_Alert"],
		className: "alert center",

		initialize: function(){
			this.$el.addClass(this.model.attributes.alertClass);
		}
	});

	

});