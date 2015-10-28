StudentAccount = new Marionette.Application();

StudentAccount.navigate = function(route, options){
	options || (options = {});
	Backbone.history.navigate(route, options);
	if(StudentAccount.rootView){
		StudentAccount.rootView.alertRegion.empty();
	}
};

StudentAccount.getCurrentRoute = function(){
	return Backbone.history.fragment;
};

StudentAccount.on("start", function(){		

	//hack for changing bg color on body
	$('body').attr("style", "background-color:#f1f1f1");
	
	
	if(!Backbone.History.started){		
		Backbone.history.start();	
	}

	StudentAccount.trigger("header-and-leftnav"); //trigger target is the router

	if(this.getCurrentRoute() === ""){		
		StudentAccount.trigger("classrooms");	//trigger target is the router
	}
	
});


