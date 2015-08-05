//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom", function(Classroom, TeacherAccount, Backbone, Marionette, $, _){
	
	Classroom.HeaderView = Marionette.ItemView.extend({				
		template: JST["teacher/templates/TeacherApp_Classroom_Header"],					
		tagName: "div",		
		// model: TeacherAccount.TeacherApp.Classroom.Models.Classroom,

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
		template: JST["teacher/templates/TeacherApp_Classroom_Layout"],			
		regions:{
			headerRegion: "#classroom_header_region",
			mainRegion: '#classroom_main_region'
		},

		onChildviewClassroomShowScores: function(view){

			TeacherAccount.navigate('classroom/scores/' + view.model.attributes.id);

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.startScoresApp(this, "read");

		},

		onChildviewClassroomShowEditScores: function(view){
			
			TeacherAccount.navigate('classroom/edit_scores/' + view.model.attributes.id);

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.startScoresApp(this, "edit");

		}

		
	})
	

});