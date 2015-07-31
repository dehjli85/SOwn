//= require teacher/teacher

TeacherAccount.module("TeacherApp", function(TeacherApp, TeacherAccount, Backbone, Marionette, $, _){
	
	TeacherApp.HeaderView = Marionette.ItemView.extend({				
		template: JST["teacher/templates/TeacherApp_Header"],
		tagName: "nav",
		className: "navbar navbar-inverse navbar-fixed-top"
			
	});

	TeacherApp.LeftNavView = Marionette.ItemView.extend({				
		template: JST["teacher/templates/TeacherApp_LeftNav"],
		tagName: "div",
		className: "col-sm-3 col-md-2 sidebar",

		events: {
			"click li" : "makeNavActive"
		},

		triggers:{
			"click @ui.navActivities": "start:activities:app"
		},

		ui:{
			navClassroom: "[ui-nav-classroom]",
			navActivities: "[ui-nav-activities]",
			navStudents: "[ui-nav-students]"
		},

		makeNavActive: function(e){
			
			if(!($(e.target).attr("data-target") == "#comingSoonModal")){
				$('li').removeClass("active");
				$(e.target).parent().addClass("active");	
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
			alertRegion: "#alert_region"
		},

		onChildviewTeacherappShowClassroomScores: function(view){
			console.log("LayoutView: heard show:classroom:view");			
			
			//start the classroom app in the main region, have it display the scores

			TeacherAccount.TeacherApp.Main.Controller.startClassroomApp(view.model.id, 'scores');


		},

		onChildviewStartActivitiesApp: function(view){
			TeacherAccount.TeacherApp.Main.Controller.startActivitiesApp("index");
		}
	}),

	TeacherApp.AlertView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Alert"],
		className: "alert center",

		initialize: function(){
			this.$el.addClass(this.model.attributes.alertClass);
		}
	})

});