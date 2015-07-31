//= require teacher/teacher

TeacherAccount.module("TeacherApp.Classroom.Scores", function(Scores, TeacherAccount, Backbone, Marionette, $, _){


	Scores.SearchBarView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_SearchBar"],			
		className: "col-sm-5",
		triggers: {
			"submit [ui-search-form]":"filter:search:classroom:scores:view"
		},
		ui:{
			searchInput: "[ui-search-input]"
		}
	});

	Scores.TagView = Marionette.ItemView.extend({
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_Tag"],			
		tagName: "li",
		triggers: {
			"click a":"filter:tag:classroom:scores:view"			
		}
		
	});

	Scores.TagCollectionView = Marionette.CollectionView.extend({
		childView: Scores.TagView,
		tagName: "ul",
		className: "list-inline col-sm-12",
		onChildviewFilterTagClassroomScoresView: function(){
			console.log("heard filter tag click");
		},
		
		
	});

	Scores.StudentPerformanceView = Marionette.ItemView.extend({
		tagName: "tr",
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_StudentPerformance"],
		initialize : function (options) {
	    this.model.attributes.activitiesCount = options.activitiesCount;	    
	  }
	});

	Scores.ScoresView = Marionette.CompositeView.extend({
		tagName: "div",
		className: "classroom-tab-content",
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_Scores"],
		childView: Scores.StudentPerformanceView,
		childViewContainer: "tbody",
		childViewOptions: function(model, index){			
			return {activitiesCount: this.model.attributes.activities.length}
		},

		ui:{
			studentHeader: "[ui-student-header]"
		},

		events: {
			"click .activity_header": "sortActivityHeader",
			"click @ui.studentHeader": "sortByName"
		},

		sortByName: function(){
			console.log(this.collection);
			this.collection.comparator = function(item){
				return [item.get("student").last_name, item.get("student").first_name];
				
			}
			this.collection.sort();
		},

		sortActivityHeader: function(e){

			index = parseInt($(e.target).attr("id").replace("header_",""));
			console.log(index);
			
			this.collection.comparator = function(item){
				
				
				if(item.attributes.student_performance[index]){
					
					if(item.attributes.student_performance[index].activity_type == 'scored'){
						return -item.attributes.student_performance[index].performance_pretty;
					}				
					else if (item.attributes.student_performance[index].activity_type == 'completion'){
						if(item.attributes.student_performance[index].completed_performance == 't'){
							console.log('completed!');
							return 0;
						}							
						else{
							return 1;							
						}
					}
					else{
						return Number.MAX_VALUE;
					}

				}
				else
					return Number.MAX_VALUE;

			};

			this.collection.sort();
			// console.log(this.collection);	
		}

	});

	Scores.LayoutView = Marionette.LayoutView.extend({
		template: JST["teacher/templates/TeacherApp_Classroom_Scores_Layout"],			
		regions:{			
			searchBarRegion: "#search_bar_region",
			tagsRegion: "#tags_region",
			scoresRegion: '#scores_region'
		},

		onChildviewFilterSearchClassroomScoresView: function(view){
			console.log("search form submitted");

			var scoresLayoutView = this;

			var jqxhr = $.get("/teacher/classroom_activities_and_performances?id=" + this.model.attributes.classroomId + "&search_term=" + encodeURIComponent(view.ui.searchInput.val()), function(){
				console.log('get request made: ' + scoresLayoutView.model.attributes.classroomId);
			})
			.done(function(data) {

				console.log(data);

				var activity_indices = {};				
				for(var i=0; i < data.activities.length; i++){					
					activity_indices[data.activities[i].id] = i;
				}

				var students = [];								
				var student_indices = {};
				for(var i=0; i < data.students.length; i++){												
					student_indices[data.students[i].id] = i;
					students[i] = {student: data.students[i], student_performance: []};
				}

				for(var i=0; i < data.student_performances.length; i++){	
					var activities_index = activity_indices[data.student_performances[i].activity_id];					
					var student_index = student_indices[data.student_performances[i].student_user_id];					
					
					if(!students[student_index].student_performance[activities_index] || ((new Date(students[student_index].student_performance[activities_index].performance_date.replace(/T|Z/g, " "))) < (new Date(data.student_performances[i].performance_date.replace(/T|Z/g, " ")))))
						students[student_index].student_performance[activities_index] = data.student_performances[i];
				}

				// //create a new composite view for the table
				var activitiesModel = new TeacherAccount.TeacherApp.Classroom.Scores.Models.Activities({activities:data.activities});
				var studentPerformancesCollection = new TeacherAccount.TeacherApp.Classroom.Scores.Models.StudentPerformanceCollection(students);

				var scoresView = new TeacherAccount.TeacherApp.Classroom.Scores.ScoresView({collection: studentPerformancesCollection, model:activitiesModel});
				console.log(scoresLayoutView);
				scoresLayoutView.scoresRegion.show(scoresView);
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});

		},

		onChildviewFilterTagClassroomScoresView: function(view){
			console.log("layout heard filter tag click");
			console.log(view.model.attributes.classroomId);

			//re-render scores with just the data for the respective tag
			var scoresLayoutView = this;

			var jqxhr = $.get("/teacher/classroom_activities_and_performances?id=" + this.model.attributes.classroomId + "&tag_id=" + view.model.id, function(){
				console.log('get request made: ' + scoresLayoutView.model.attributes.classroomId);
			})
			.done(function(data) {

				console.log(data);

				var activity_indices = {};				
				for(var i=0; i < data.activities.length; i++){					
					activity_indices[data.activities[i].id] = i;
				}

				var students = [];								
				var student_indices = {};
				for(var i=0; i < data.students.length; i++){												
					student_indices[data.students[i].id] = i;
					students[i] = {student: data.students[i], student_performance: []};
				}

				for(var i=0; i < data.student_performances.length; i++){	
					var activities_index = activity_indices[data.student_performances[i].activity_id];					
					var student_index = student_indices[data.student_performances[i].student_user_id];					
					
					if(!students[student_index].student_performance[activities_index] || ((new Date(students[student_index].student_performance[activities_index].performance_date.replace(/T|Z/g, " "))) < (new Date(data.student_performances[i].performance_date.replace(/T|Z/g, " ")))))
						students[student_index].student_performance[activities_index] = data.student_performances[i];
				}

				// //create a new composite view for the table
				var activitiesModel = new TeacherAccount.TeacherApp.Classroom.Scores.Models.Activities({activities:data.activities});
				var studentPerformancesCollection = new TeacherAccount.TeacherApp.Classroom.Scores.Models.StudentPerformanceCollection(students);

				var scoresView = new TeacherAccount.TeacherApp.Classroom.Scores.ScoresView({collection: studentPerformancesCollection, model:activitiesModel});
				console.log(scoresLayoutView);
				scoresLayoutView.scoresRegion.show(scoresView);
	     	
		  })
		  .fail(function() {
		  	console.log("error");
		  })
		  .always(function() {
		   
			});
		}

	})

	

	

});