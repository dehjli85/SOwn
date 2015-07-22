PublicPages = new Marionette.Application()

PublicPages.addRegions({
	mainRegion: "#main_region"
});

PublicPages.navigate = function(route, options){
	options || (options = {});
	Backbone.history.navigate(route, options);
};

PublicPages.getCurrentRoute = function(){
	return Backbone.history.fragment;
};

PublicPages.on("start", function(){		

	// console.log("starting app...")
	if(!Backbone.History.started){
		// console.log("starting history...")
		Backbone.history.start();

		if(this.getCurrentRoute() === ""){
			// console.log("empty fragment: triggering index:home");
			PublicPages.trigger("index:home");			
		}
	}



});

