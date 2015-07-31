TeacherAccount.module("TeacherApp.Activities.Models", function(Models, TeacherAccount, Backbone, Marionette, $, _){
	
	Models.IndexActivity = Backbone.Model.extend({});	

	Models.IndexActivitiesCollection = Backbone.Collection.extend({
		model: Models.IndexActivity
	});

	Models.Activity = Backbone.Model.extend({});

	Models.Tag = Backbone.Model.extend({});

	Models.TagCollection = Backbone.Collection.extend({
		model: Models.Tag
	})
	

});