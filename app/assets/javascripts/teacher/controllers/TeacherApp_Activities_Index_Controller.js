//= require teacher/teacher

TeacherAccount.module("TeacherApp.Activities.Index", function(Index, TeacherAccount, Backbone, Marionette, $, _){

	Index.Controller = {

		showIndex: function(){			

			//Create the Index Layout View
			var indexLayoutView = new TeacherAccount.TeacherApp.Activities.Index.LayoutView();
			TeacherAccount.rootView.mainRegion.show(indexLayoutView);
			
			Index.Controller.showIndexHeaderView(indexLayoutView);

			Index.Controller.showIndexActivitiesCompositeView(indexLayoutView);

			
		},

		showIndexHeaderView: function(indexLayoutView){

			var headerView = new TeacherAccount.TeacherApp.Activities.Index.HeaderView();
			indexLayoutView.headerRegion.show(headerView);
		},

		showIndexActivitiesCompositeView: function(indexLayoutView, tagId, searchTerm){

			// create activity assignment view and add it to the layout
			var getUrl = "/teacher/teacher_activities_and_tags?";
			if(tagId != null){
				getUrl += "tagId=" + tagId;
			}
			if(searchTerm != null){
				getUrl += "searchTerm=" + searchTerm;
			}
			
			var jqxhr = $.get(getUrl, function(){
				console.log('get request for teacher activities and tags made');
			})
			.done(function(data) {

				console.log(data);

				var activitiesCollection = new TeacherAccount.TeacherApp.Activities.Index.Models.ActivitiesCollection(data);

				var activitiesCompositeView = new TeacherAccount.TeacherApp.Activities.Index.ActivitiesCompositeView({collection: activitiesCollection});
				indexLayoutView.mainRegion.show(activitiesCompositeView);
				
				
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});			

		},

	}

})