var GROUP_CHECK_BOX = (function(){

	function GroupCheckBox(masterCheckBoxId, groupCheckBoxClass){
		this.masterCheckBox = $('#' + masterCheckBoxId);
		this.groupCheckBoxes = $('.' + groupCheckBoxClass);
		this.groupCheckBoxClass = groupCheckBoxClass

		var obj = this; 

		for(var i=0; i<this.groupCheckBoxes.length; i++) {
	    $(this.groupCheckBoxes[i]).click(function() {
	        var checkedCount = $('.' + obj.groupCheckBoxClass + ':checked').length;
	        
	        obj.masterCheckBox.prop('checked',checkedCount > 0);
	        obj.masterCheckBox.prop('indeterminate', checkedCount > 0 && checkedCount < obj.groupCheckBoxes.length);	        
	    });
		}

		this.masterCheckBox.click(function() {
	    for(var i=0; i<obj.groupCheckBoxes.length; i++) {
	        obj.groupCheckBoxes[i].checked = this.checked;

	    }
		});
	}

	GroupCheckBox.prototype.randomCheck = function() {
		for(var i = 0; i< this.groupCheckBoxes.length; i++){
			console.log(i);

			$(this.groupCheckBoxes[i]).prop('checked', Math.random() > .5);
		}
	};

	return{
		GroupCheckBox: GroupCheckBox
	}

})();