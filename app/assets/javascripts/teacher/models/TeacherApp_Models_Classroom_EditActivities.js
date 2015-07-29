TeacherAccount.module("TeacherApp.Classroom.EditActivities.Models", function(Models, TeacherAccount, Backbone, Marionette, $, _){
	
	Models.Activity = Backbone.Model.extend({});	

	Models.ActivitiesCollection = Backbone.Collection.extend({
		model: Models.Activity
	})

	Models.Verification = Backbone.Model.extend({});

	Models.VerificationsCollection = Backbone.Collection.extend({
		model: Models.Verification
	})

	Models.Alert = Backbone.Model.extend({});
	

});