Admin = new Marionette.Application()

Admin.navigate = function(route, options){
	options || (options = {});
	Backbone.history.navigate(route, options);

	if(Admin.rootView.alertRegion){
		Admin.rootView.alertRegion.empty();
	}
};

Admin.getCurrentRoute = function(){
	return Backbone.history.fragment;
};

Admin.on("start", function(){		

	if(!Backbone.History.started){
		Backbone.history.start();

		if(this.getCurrentRoute() === ""){
			Admin.trigger("index:home");			
		}
	};
	
});

