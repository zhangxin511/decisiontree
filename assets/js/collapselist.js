$(document).ready(function(){
	$(".accordion-inner").each(function(){
		var parent=$(this).attr("code");
		var element=$(this);
		$.ajax({
			type:"post",
			url: 'index.cfm?action=code.getChildrenbyParent',
			data: {parent: parent}
		})
		.done(function( response ) {
			var table = $('<table></table>').addClass('table').addClass('table-striped').addClass('table-bordered').addClass('table-hover').addClass('table-condensed');
			var header=$('<thead></thead>');
			var headerrow = $('<tr></tr>');
			headerrow.append($('<th></th').text("ID"));
			headerrow.append($('<th></th').text("Name"));
			headerrow.append($('<th></th').text("Char Code"));
			headerrow.append($('<th></th').text("Delete?"));
			header.append(headerrow);
			table.append(header);
			var tbody=$('<tbody></tbody>');
			for(i=0; i<response.DATA.length; i++){
				var row = $('<tr></tr>');
				row.append($('<td></td>').html(response.DATA[i][3]));
				row.append($('<td></td>').html("<a href='index.cfm?action=code.form&id="+response.DATA[i][3]+"'>"+response.DATA[i][0]+"</a>"));
				row.append($('<td></td>').html(response.DATA[i][2]));
				row.append($('<td></td>').html("<a href='index.cfm?action=code.delete&id="+response.DATA[i][3]+"'>DELETE</a>"));
			    tbody.append(row);
			}
			table.append(tbody);
			element.append(table);

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
