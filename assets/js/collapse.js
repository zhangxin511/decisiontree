function collapse(elem, hor){
	var info=$(elem).parent().attr("id");
	var curlevel=info.substr(-1);
	var nextleve=parseInt(curlevel)+1;		
	var codeid=info.substr(0,info.length-1);
	//removed for new information refresh;
	$(".alert").remove();	
	$("#infotable").remove();
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

		$.ajax({
			type:"post",
			url: 'index.cfm?action=code.update',
			data: {condition: condition}
		})
		.done(function( response ) {
			console.log(response);
			var id="#code-container"+curlevel;
						
			jQuery('<div/>', {
				id: "tab-content"+curlevel,
				"class":'tab-content'
			}).appendTo(id);

			jQuery('<div/>', {
				id: "tab"+codeid+curlevel,
				"class":'tab-pane active'
			}).appendTo("#tab-content"+curlevel);	

			if(hor){
				jQuery('<div/>', {
					id: "code-container"+nextleve,
					"class":'tabbable tabs'
				}).appendTo("#tab"+codeid+curlevel);
			}else{
				jQuery('<div/>', {
					id: "code-container"+nextleve,
					"class":'tabbable tabs-left'
				}).appendTo("#tab"+codeid+curlevel);				
			}
			
			jQuery('<div/>', {
				"class":'alert alert-info'
			}).appendTo("#code-container"+nextleve);
			var tablevel=parseInt(curlevel)+1;
			$(".alert").html("<span class='text-error'>Decision tab "+tablevel+ ":</span> <strong>"+response[0].DATA.length+"</strong> indicators found.");
			if(response[1].DATA.length>1){
				jQuery('<ul/>', {
					id: "nav"+nextleve,
					"class":'nav nav-tabs'
				}).appendTo("#code-container"+nextleve);
	
				for(j=0;j<response[1].DATA.length;j++){
					var tabidchar=response[1].DATA[j][3].toString();
					jQuery('<li/>', {
						id:tabidchar+nextleve
					}).appendTo("#nav"+nextleve);
					if(hor){
						jQuery('<a/>', {
							href:"#tab"+tabidchar+nextleve,
							"data-toggle":"tab",
							onclick:"collapse(this,true)",
							text:response[1].DATA[j][0]
						}).appendTo("#"+tabidchar+nextleve);
					}else{
						jQuery('<a/>', {
							href:"#tab"+tabidchar+nextleve,
							"data-toggle":"tab",
							onclick:"collapse(this,false)",
							text:response[1].DATA[j][0]
						}).appendTo("#"+tabidchar+nextleve);						
					}
				}
			}
			jQuery('<div/>', {
				id:"infotable",
				style:"float:left; width:100%"
				
			}).appendTo("#code-container"+nextleve);
			
			var table = $('<table></table>').addClass('table').addClass('table-striped').addClass('table-bordered').addClass('table-hover').addClass('table-condensed');
			var header=$('<thead></thead>');
			var headerrow = $('<tr></tr>');
			headerrow.append($('<th></th').text("Indicator ID"));
			headerrow.append($('<th></th').text("Indicator Description"));
			headerrow.append($('<th></th').text("Indicator char code"));
			headerrow.append($('<th></th').text("CABG"));
			headerrow.append($('<th></th').text("PCI"));
			header.append(headerrow);
			table.append(header);
			var tbody=$('<tbody></tbody>');
			for(i=0; i<response[0].DATA.length; i++){
				var row = $('<tr></tr>');
				row.append($('<td></td>').text(response[0].DATA[i][4]));
				row.append($('<td></td>').text(response[0].DATA[i][0]));
				row.append($('<td></td>').text(response[0].DATA[i][1]));
				row.append($('<td></td>').text(response[0].DATA[i][2]));
				row.append($('<td></td>').text(response[0].DATA[i][3]));
			    tbody.append(row);
			}
			table.append(tbody);
			$("#infotable").append(table);
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