PublicPages = new Marionette.Application()

PublicPages.navigate = function(route, options){
	options || (options = {});
	Backbone.history.navigate(route, options);

	if(PublicPages.rootView.alertRegion){
		PublicPages.rootView.alertRegion.empty();
	}
};

PublicPages.getCurrentRoute = function(){
	return Backbone.history.fragment;
};

PublicPages.on("start", function(){		

	if(!Backbone.History.started){
		Backbone.history.start();

		if(this.getCurrentRoute() === ""){
			PublicPages.trigger("index:home");			
		}
	};

	console.log("starting google api loading...");
	var start = moment();
	// gapi.load('auth2', function() {
 //    gapi.auth2.init({
 //      client_id: '916932200710-kk91r5rbn820llsernmbjfgk9r5s67lq.apps.googleusercontent.com',
 //    }).then(function(){
 //    	auth2 = gapi.auth2.getAuthInstance();
	// 		console.log("google api loaded...: " + (moment() - start) + 'ms');

 //    }) ;
 //  });


});

