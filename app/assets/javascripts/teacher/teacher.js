TeacherAccount = new Marionette.Application();

TeacherAccount.navigate = function(route, options){
	options || (options = {});
	Backbone.history.navigate(route, options);
	if(TeacherAccount.rootView){
		TeacherAccount.rootView.alertRegion.empty();
	}
};

TeacherAccount.getCurrentRoute = function(){
	return Backbone.history.fragment;
};

TeacherAccount.on("start", function(){		
	
	if(!Backbone.History.started){		
		Backbone.history.start();	
	}

	TeacherAccount.trigger("header-and-leftnav");

	if(this.getCurrentRoute() === ""){		
		TeacherAccount.trigger("classrooms");			
	}

});

