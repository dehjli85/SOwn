//= require public_pages/public_pages

PublicPages.module("SignUpAndLoginApp.SignUp", function(SignUp, PublicPages, Backbone, Marionette, $, _){
	
	SignUp.TeacherSignUpView = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_SignUp_TeacherSignUpView"],																			    
		className: "container-fluid",

		events:{
			//"click input.js-sign-up": "signUp",
			"click @ui.firstNameFormGroup": "dosomething"
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
			passwordInputDiv: '[ui-password-input-div]'
		},

		triggers:{
			"click input.js-sign-up": "sign-up:sign-up"
		},

		showErrors: function(errors){
			var jsonErrors = $.parseJSON(errors);
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

		clearErrors: function(){
			$('.error-label').remove();
			this.ui.firstNameFormGroup.removeClass("has-error");
			this.ui.lastNameFormGroup.removeClass("has-error");
			this.ui.emailFormGroup.removeClass("has-error");
			this.ui.passwordFormGroup.removeClass("has-error");
			// this.ui.firstNameFormGroup.empty();
			// this.ui.lastNameFormGroup.empty();
			// this.ui.emailFormGroup.empty();
			// this.ui.passwordFormGroup.empty();
		}

		
	});

	SignUp.StudentSignUpView = Marionette.ItemView.extend({
		template: JST["public_pages/templates/SignUpAndLogin_SignUp_StudentSignUpView"],																			    
		className: "container-fluid",		

		ui:{
			signUpForm: 'form',
			firstNameFormGroup: '[ui-first-name-form-group-div]',
			firstNameInputDiv: '[ui-first-name-input-div]',
			lastNameFormGroup: '[ui-last-name-form-group-div]',
			lastNameInputDiv: '[ui-last-name-input-div]',
			emailFormGroup: '[ui-email-form-group-div]',
			emailInputDiv: '[ui-email-input-div]',
			passwordFormGroup: '[ui-password-form-group-div]',
			passwordInputDiv: '[ui-password-input-div]'
		},

		triggers:{
			"click input.js-sign-up": "sign-up:sign-up"
		},

		showErrors: function(errors){
			var jsonErrors = $.parseJSON(errors);
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

		clearErrors: function(){
			$('.error-label').remove();
			this.ui.firstNameFormGroup.removeClass("has-error");
			this.ui.lastNameFormGroup.removeClass("has-error");
			this.ui.emailFormGroup.removeClass("has-error");
			this.ui.passwordFormGroup.removeClass("has-error");
			// this.ui.firstNameFormGroup.empty();
			// this.ui.lastNameFormGroup.empty();
			// this.ui.emailFormGroup.empty();
			// this.ui.passwordFormGroup.empty();
		}

		
	});

});