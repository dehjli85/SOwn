//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.SignUp", function(SignUp, PublicPages, Backbone, Marionette, $, _){
	
	SignUp.SignUpView = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_SignUp_SignUpView"], 
		className: "container-fluid",

		events:{
			"click @ui.googleSignUpButton": "signUpWithGoogle",
			"click @ui.createAccountButton": "revealAccountForm"

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
			signUpButton: "[ui-sign-up-button]"
		},

		triggers:{
			"click input.ui-sign-up": "sign-up",
			"click @ui.signUpButton": "sign:up"
		},

		onSignUp: function(args){			
			PublicPages.SignUpAndLoginApp.SignUp.Controller.signUp(this);
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
		},

		signUpWithGoogle: function(e){
			e.preventDefault();
			SignUp.Controller.signUpWithGoogle(this.model.attributes.user_type);			
		},

		

		clearErrors: function(){
			$('.error-label').remove();
			this.ui.firstNameFormGroup.removeClass("has-error");
			this.ui.lastNameFormGroup.removeClass("has-error");
			this.ui.emailFormGroup.removeClass("has-error");
			this.ui.passwordFormGroup.removeClass("has-error");
		}

		
	});

	SignUp.LayoutView = Marionette.LayoutView.extend({
		regions:{
			mainRegion: "#main_region",
			alertRegion: "#alert_region"
		}

	})

});