TeacherAccount.module("TeacherApp.Classroom.Scores.Models", function(Models, TeacherAccount, Backbone, Marionette, $, _){
	
	Models.Tag = Backbone.Model.extend({});	

	Models.TagCollection = Backbone.Collection.extend({
		model: Models.Tag
	})

	Models.Activities = Backbone.Model.extend({});

	Models.StudentPerformance = Backbone.Model.extend({});

	Models.StudentPerformanceCollection = Backbone.Collection.extend({
		model: Models.StudentPerformance
	});

	

});