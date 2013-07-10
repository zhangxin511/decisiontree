//document.ready register for suboption loading
$(document).ready(function(){
	$('.group').each(function(){
		var parent=$(this).attr("code");
		var element=$(this);
		$.ajax({
			type:"post",
			url: 'index.cfm?action=code.getChildrenbyParent',
			data: {parent: parent}
		})
		.done(function( response ) {
			for(i=0; i<response.DATA.length; i++){
				var opt = $('<option></option>').attr('value', response.DATA[i][3]).html(response.DATA[i][0]);
				element.append(opt);

			}
			console.log(element.html());			
		})

		.fail(function( jqxhr, textStatus, error ) {
			alert("There was a problem running method.");
			if( console && console.log ) {
				console.log("Error: "+textStatus+", "+error);
			}				
		})
		.always(function() { 

		});		
	});
});

//document.ajaxStop register for the translation after all ajax request
$(document).ajaxStop(function() {
	$('.multiselect').multiselect({
 		buttonClass: 'btn',
  		buttonWidth: 'auto',
  		buttonContainer: '<div class="btn-group" />',
  		maxHeight: false,
  		enableFiltering:true,
  		enableCaseInsensitiveFiltering: true,
  		filterPlaceholder: 'Search a code',
  		buttonText: function(options) {
        	if (options.length == 0) {
          		return 'None selected <b class="caret"></b>';
        	}else if (options.length > 4) {
          		return options.length + ' selected  <b class="caret"></b>';
       	 	}else {
          		var selected = '';
          		options.each(function() {
            		selected += $(this).text() + ', ';
          		});
          		return selected.substr(0, selected.length -2) + ' <b class="caret"></b>';
        	}
		}
	})	
});