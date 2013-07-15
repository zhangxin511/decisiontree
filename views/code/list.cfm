<ul class="breadcrumb">
	Your current location:  <li><a href="#">Home</a><span class="divider">/</span></li>
	<li><a href="#">DST Management</a> <span class="divider">/</span></li>
	<li class="active">Angiographic and Clinical Indicators (By Sequence)</li>
</ul>
<cfset local.tempcodes = rc.data>
<cfset local.codes=ArrayNew(1)>

<cfloop collection="#local.tempcodes#" item="local.id">
	<cfset local.codes[local.id] = local.tempcodes[local.id]>
</cfloop>

<cfoutput>
<table class="table table-bordered table-striped table-hover table-condense">
	<thead>
		<tr>
			<th>Id</th>
			<th>Name</th>
			<th>Parent</th>
			<th>Char Code</th>
			<th>Delete?</th>
		</tr>
	</thead>
	<tbody>		
		<cfloop index="codeindex" from="1" to="#ArrayLen(local.codes)#" >
			<cfif structKeyExists(local.tempcodes, "#codeindex#")>			
				<cfset local.code = local.codes[codeindex]>		
				<tr>
					<td>#local.code.getID()#</td>
					<td><a href="index.cfm?action=code.form&id=#local.code.getID()#&way=list">#local.code.getName()#</a></td>
					<cfif #local.code.getParent_ID()#>
						<td>#local.code.getParent().getName()# (#local.code.getParent().getChar_Code()#)</td>
					<cfelse>
						<td>Root Node</td>
					</cfif>
					
					<td>#local.code.getChar_Code()#</td>
					<td><a href="index.cfm?action=code.delete&id=#local.code.getID()#">DELETE</a></td>
				</tr>
			</cfif>
		</cfloop>
	</tbody>
</table>
</cfoutput>

<a href="index.cfm?action=code.form&way=list">Add new code?</a>