$(document).ready(function(){	
	function help(){
		if($('.selectpicker').val()==0){
			$('#help').show('slow')
		}else{
			$('#help').hide('slow')
		}	
	}
	
	$("#char_code").keyup(function() {
		$(this).val($(this).val().toUpperCase());
	});
	help();
	$('.selectpicker').change(function(){
		help()
	});
})