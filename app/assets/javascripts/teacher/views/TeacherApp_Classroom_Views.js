//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom", function(Classroom, TeacherAccount, Backbone, Marionette, $, _){
	
	Classroom.HeaderView = Marionette.ItemView.extend({				
		template: JST["teacher/templates/TeacherApp_Classroom_Header"],					
		tagName: "div",		
		// model: TeacherAccount.TeacherApp.Classroom.Models.Classroom,

		triggers: {
			
		},

		ui:{
			
		},

		
			
	});

	Classroom.LayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Classroom_Layout"],			
		regions:{
			headerRegion: "#classroom_header_region",
			mainRegion: '#classroom_main_region'
		}
	})
	

});