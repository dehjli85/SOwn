//= require teacher/teacher

TeacherAccount.module("TeacherApp.Activities", function(Activities, TeacherAccount, Backbone, Marionette, $, _){

	Activities.Controller = {
		
		showActivitiesIndex: function(){			

			Activities.Index.Controller.showIndex();
			
		}
	}

})