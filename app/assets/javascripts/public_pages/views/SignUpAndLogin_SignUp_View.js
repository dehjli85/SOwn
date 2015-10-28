//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.SignUp", function(SignUp, PublicPages, Backbone, Marionette, $, _){
	
	SignUp.SignUpView = Marionette.LayoutView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_SignUp_SignUpView"], 
		className: "container-fluid container-fluid_no-padding",

		events:{
			"click @ui.googleSignUpButton": "signUpWithGoogle",
			"click @ui.createAccountButton": "revealAccountForm"

		},

		regions:{
			flashMessageRegion: "[ui-flash-message-region]"
		},

		ui:{
			signUpForm: 'form',
			firstNameFormGroup: '[ui-first-name-form-group-div]',
			firstNameInputDiv: '[ui-first-name-input-div]',
			lastNameFormGroup: '[ui-last-name-form-group-div]',
			lastNameInputDiv: '[ui-last-name-input-div]',
			emailFormGroup: '[ui-email-form-group-div]',
			emailInputDiv: '[ui-email-input-div]',
			passwordFormGroup: '[ui-password-form-group-div]',
			passwordInputDiv: '[ui-password-input-div]',
			googleSignUpButton: "[ui-google-sign-up-button]",
			orDiv: "[ui-or-div]",
			googleSignUpDiv: "[ui-google-sign-up-div]",
			standardFormDiv: "[ui-standard-form-div]",
			createAccountButton: "[ui-create-account-button]",
			createAccountDiv: "[ui-create-account-div]",
			signUpButton: "[ui-sign-up-button]",
			termsOfServiceLink: "[ui-terms-of-service-link]",
			privacyLink: "[ui-privacy-link]",
			privacyTosCheckbox: "[ui-privacy-tos-checkbox]",
			tosPrivacyFormGroup:"[ui-tos-privacy-form-group-div]",
			tosPrivacyInputDiv: "[ui-tos-privacy-input-div]"
		},

		triggers:{
			"click @ui.signUpButton": "sign:up",
			"click @ui.privacyLink": "show:privacy:policy",
			"click @ui.termsOfServiceLink": "show:terms:of:service"
		},

		onSignUp: function(args){		
			if(this.ui.privacyTosCheckbox.prop("checked"))	{
				PublicPages.SignUpAndLoginApp.SignUp.Controller.signUp(this);
			}
			else{
				errors = {};
				errors.tos_privacy = ["You must agree to the Terms of Service and Privacy Policy to sign up"];
				this.showErrors(errors);
			}
		},


		revealAccountForm: function(){
			this.ui.standardFormDiv.attr("style", "display:block");			
			this.ui.createAccountDiv.attr("style", "display:none");
		},

		showErrors: function(errors){
			var jsonErrors = errors;
			if(jsonErrors.first_name){
				this.ui.firstNameFormGroup.addClass("has-error");
				$('<label class="control-label error-label" for="inputFirstName">First Name ' + jsonErrors.first_name[0] + '</label>').appendTo(this.ui.firstNameInputDiv);
			}
			if(jsonErrors.last_name){
				this.ui.lastNameFormGroup.addClass("has-error");
				$('<label class="control-label error-label" for="inputLastName">Last Name ' + jsonErrors.last_name[0] + '</label>').appendTo(this.ui.lastNameInputDiv);
			}
			if(jsonErrors.email){
				this.ui.emailFormGroup.addClass("has-error");
				$('<label class="control-label error-label" for="inputEmail">Email ' + jsonErrors.email[0] + '</label>').appendTo(this.ui.emailInputDiv);
			}
			if(jsonErrors.password){
				this.ui.passwordFormGroup.addClass("has-error");
				$('<label class="control-label error-label" for="inputPassword">Password ' + jsonErrors.password[0] + '</label>').appendTo(this.ui.passwordInputDiv);
			}
			if(jsonErrors.tos_privacy){
				this.ui.tosPrivacyFormGroup.addClass("has-error");
				$('<label class="control-label error-label" for="inputTosPrivacy">' + jsonErrors.tos_privacy[0] + '</label>').appendTo(this.ui.tosPrivacyInputDiv);
			}
		},

		signUpWithGoogle: function(e){
			e.preventDefault();
			SignUp.Controller.signUpWithGoogle(this.model.attributes.user_type, this);			
		},

		

		clearErrors: function(){
			$('.error-label').remove();
			this.ui.firstNameFormGroup.removeClass("has-error");
			this.ui.lastNameFormGroup.removeClass("has-error");
			this.ui.emailFormGroup.removeClass("has-error");
			this.ui.passwordFormGroup.removeClass("has-error");
			this.ui.tosPrivacyFormGroup.removeClass("has-error");

		}

		
	});

	SignUp.LayoutView = Marionette.LayoutView.extend({
		regions:{
			mainRegion: "#main_region",
			alertRegion: "#alert_region"
		}

	})

});