//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Home", function(Home, PublicPages, Backbone, Marionette, $, _){
	
	Home.MainView = Marionette.LayoutView.extend({				
			template: JST["public_pages/templates/SignUpAndLogin_Home"],
			className: "",

			events:{
				"click @ui.videoDiv1": "inspirationVideoPlayed",
				"click @ui.videoDiv2": "howItWorksVideoPlayed",
			},

			triggers: {
				"click @ui.teacherSignUpButton" : "home:teacher:sign:up",
				"click @ui.studentSignUpButton" : "home:student:sign:up",
			},

			ui:{
				teacherSignUpButton: "[ui-teacher-sign-up-button]",
				studentSignUpButton: "[ui-student-sign-up-button]",
				videoDiv1: "[ui-video-div-one]",
				videoDiv2: "[ui-video-div-two]",
			},

			howItWorksVideoPlayed: function(e){
    		ga('send', 'event', 'public_pages', 'video_played', 'how_it_works');
			},

			inspirationVideoPlayed: function(e){
    		ga('send', 'event', 'public_pages', 'video_played', 'inspiration');
			}

	});

	Home.TermsOfServiceView = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_TermsOfService"],
	});

	Home.PrivacyPolicyView = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_PrivacyPolicy"],
	});

});