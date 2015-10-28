Admin.module("Models", function(Models, Admin, Backbone, Marionette, $, _){

	Models.SearchResultsCollection = Backbone.Collection.extend({
		modelId: function (attrs) {
      return attrs.user_type + "-" + attrs.id;
    }
	});

});