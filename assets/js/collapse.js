function collapse(elem){
	var info=$(elem).parent().attr("id");
	var curlevel=info.substr(-1);
	var nextleve=parseInt(curlevel)+1;		
	var codeid=info.substr(0,info.length-1);
	$(".alert").remove();
	$("#info").remove();
	$(elem).parent().parent().next().remove();	

	setTimeout(function() {		
		var condition="";
		var i=0;
		$("#code-container0 li").each(function(){
			if($(this).attr("class")!=null&&$(this).attr("class")=="active"){
				if(i==0){
					condition+=$(this).attr("id").substr(0,$(this).attr("id").length-1);
				}else{
					condition+=","+$(this).attr("id").substr(0,$(this).attr("id").length-1);
				}
				i++;
			}			
		});
		console.log(condition);

		$.ajax({
			type:"post",
			url: 'index.cfm?action=code.update',
			data: {condition: condition}
		})
		.done(function( response ) {
			
			var id="#code-container"+curlevel;
			jQuery('<div/>', {
				"class":'alert alert-info'
			}).appendTo(id);

			$(".alert").html("Totally <strong>"+response[0].DATA.length+"</strong> records, please select one of the rest categories below to reduce numbers.");
						
			jQuery('<div/>', {
				id: "tab-content"+curlevel,
				"class":'tab-content'
			}).appendTo(id);

			jQuery('<div/>', {
				id: "tab"+codeid+curlevel,
				"class":'tab-pane active'
			}).appendTo("#tab-content"+curlevel);	

			jQuery('<div/>', {
				id: "code-container"+nextleve,
				"class":'tabbable'
			}).appendTo("#tab"+codeid+curlevel);

			jQuery('<ul/>', {
				id: "nav"+nextleve,
				"class":'nav nav-tabs'
			}).appendTo("#code-container"+nextleve);

			for(j=0;j<response[1].DATA.length;j++){
				var tabidchar=response[1].DATA[j][0].toString();
				jQuery('<li/>', {
					id:tabidchar+nextleve
				}).appendTo("#nav"+nextleve);
				jQuery('<a/>', {
					href:"#tab"+tabidchar+nextleve,
					"data-toggle":"tab",
					onclick:"collapse(this)",
					text:response[1].DATA[j][1]
				}).appendTo("#"+tabidchar+nextleve);				
			}

			jQuery('<div/>', {
				id:"info",
				"class":'row'
			}).appendTo("#code-container0");
			
			var table = $('<table></table>').addClass('table').addClass('table-striped').addClass('table-bordered');
			var header=$('<thead></thead>');
			var headerrow = $('<tr></tr>');
			headerrow.append($('<th></th').text("Selection"));
			headerrow.append($('<th></th').text("CABG"));
			headerrow.append($('<th></th').text("PCI"));
			headerrow.append($('<th></th').text("Yes?"));
			header.append(headerrow);
			table.append(header);
			var tbody=$('<tbody></tbody>');
			for(i=0; i<response[0].DATA.length; i++){
				var row = $('<tr></tr>');
				
				row.append($('<td></td>').text(response[0].DATA[i][1]));
				row.append($('<td></td>').text("CABG code..."));
				row.append($('<td></td>').text("PCI code..."));
				row.append($('<td></td>').html("<input type='checkbox'>"));
			    tbody.append(row);
			}
			table.append(tbody);
			$("#info").append(table);
			
			if( typeof console != 'undefined' ) {
				console.log(response[0]);
			}
		})

		.fail(function( jqxhr, textStatus, error ) {
			alert("There was a problem running method.");
			if( console && console.log ) {
				console.log("Error: "+textStatus+", "+error);
			}				
		})
		.always(function() { 

		});

	}, 1);		
}