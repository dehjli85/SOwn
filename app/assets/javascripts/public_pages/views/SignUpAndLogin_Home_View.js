//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.Home", function(Home, PublicPages, Backbone, Marionette, $, _){
	
	Home.MainView = Marionette.LayoutView.extend({				
			template: JST["public_pages/templates/SignUpAndLogin_Home"],
			className: "",

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

			events: {
				"click @ui.videoDiv1": "playVideo1",
				"click @ui.videoDiv2": "playVideo2",
				"hover @ui.videoDiv1": "changePlayDivColors"
			},

			playVideo1: function(e){
				e.preventDefault();
				this.ui.videoDiv1.removeClass("video");
				this.ui.videoDiv1.html('<iframe src="https://player.vimeo.com/video/142544815?autoplay=true" width="854" height="480" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>');
			},

			playVideo2: function(e){
				e.preventDefault();
				this.ui.videoDiv2.removeClass("video");
				this.ui.videoDiv2.html('<iframe src="https://player.vimeo.com/video/142545484?autoplay=true" width="854" height="408" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen ></iframe>');
			},

			changePlayDivColors: function(e){
				console.log("hello");
			}
			
	});

	Home.TermsOfServiceView = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_TermsOfService"],
	});

	Home.PrivacyPolicyView = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_PrivacyPolicy"],
	});

});