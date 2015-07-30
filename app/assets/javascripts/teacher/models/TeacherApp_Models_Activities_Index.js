TeacherAccount.module("TeacherApp.Activities.Index.Models", function(Models, TeacherAccount, Backbone, Marionette, $, _){
	
	Models.Activity = Backbone.Model.extend({});	

	Models.ActivitiesCollection = Backbone.Collection.extend({
		model: Models.Activity
	})
	

});