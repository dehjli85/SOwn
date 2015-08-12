//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom", function(Classroom, TeacherAccount, Backbone, Marionette, $, _){
	
	Classroom.HeaderView = Marionette.ItemView.extend({				
		template: JST["teacher/templates/TeacherApp_Classroom_Header"],					
		tagName: "div",		
		// model: TeacherAccount.TeacherApp.Classroom.Models.Classroom,

		triggers: {
			"click @ui.scoresLink": "classroom:show:scores",
			"click @ui.editDataLink": "classroom:show:edit:scores",
			"click @ui.editActivitiesLink": "classroom:show:edit:activities",
			"click @ui.classroomCodeLink": "classroom:show:classroom:code",
			"click @ui.editClassroomLink": "classroom:show:edit:classroom"
		},

		events:{
			"click a": "makeTabActive",
			"click @ui.classroomCodeLink": "toggleClassroomCode"
		},

		ui:{
			scoresLink: "[ui-scores-a]",			
			editDataLink: "[ui-edit-data-a]",
			editActivitiesLink: "[ui-edit-activities-a]",			
			classroomCodeLink: "[ui-show-classroom-code-a]",
			editClassroomLink: "[ui-edit-classroom-a]",
			lis: "li",
		},

		makeTabActive: function(e){
			console.log(e);
			if(!($(e.target).attr("data-target") == "#comingSoonModal") &&
				$(e.target).attr("ui-show-classroom-code-a") == null){
				this.ui.lis.removeClass("active");			
				$(e.target).parent().addClass("active");	
			}
			
			
		},

		onClassroomShowClassroomCode: function(){
			if(this.ui.classroomCodeLink.html() == "Show Classroom Code"){
				this.ui.classroomCodeLink.html("Hide Classroom Code");
			}
			else{
				this.ui.classroomCodeLink.html("Show Classroom Code");
			}
		}

		
			
	});

	Classroom.LayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Classroom_Layout"],			
		regions:{
			headerRegion: "#classroom_header_region",
			mainRegion: '#classroom_main_region', 
			alertRegion: "#classroom_alert_region"
		},

		onChildviewClassroomShowScores: function(view){

			TeacherAccount.navigate('classroom/scores/' + view.model.attributes.id);

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.startScoresApp(this, "read");

		},

		onChildviewClassroomShowEditScores: function(view){
			
			TeacherAccount.navigate('classroom/edit_scores/' + view.model.attributes.id);

			TeacherAccount.TeacherApp.Classroom.Scores.Controller.startScoresApp(this, "edit");

		},

		onChildviewClassroomShowClassroomCode: function(view){

			TeacherAccount.TeacherApp.Classroom.Controller.toggleClassroomCode(this, view.model.attributes.classroom_code);
			
		},

		onChildviewClassroomShowEditActivities: function(view){

			TeacherAccount.navigate("classroom/edit_activities/" + view.model.attributes.id);

			TeacherAccount.TeacherApp.Classroom.Controller.showClassroomEditActivities(this, view.model.attributes.id);

		},

		onChildviewClassroomShowEditClassroom: function(view){

			TeacherAccount.navigate("classroom/edit_classroom/" + view.model.attributes.id);

			TeacherAccount.TeacherApp.Classroom.Controller.showEditClassroom(this, view.model.attributes.id);

		}

		
	});

	
});