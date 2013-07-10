<ul class="breadcrumb">
	Your current location:  <li class="active"><a href="#">Home</a><span class="divider">/</span></li>
	<li><a href="#">DST Management</a> <span class="divider">/</span></li>
	<li class="active">List Rules</li>
</ul>
<cfset local.temprules = rc.data>
<cfset local.rules=ArrayNew(1)>

<cfloop collection="#local.temprules#" item="local.id">
	<cfset local.rules[local.id] = local.temprules[local.id]>
</cfloop>

<cfoutput>
<table class="table table-bordered table-striped table-hover table-condense">
	<thead>
		<tr>
			<th>Id</th>
			<th>Description</th>
			<th>Related Indicator</th>
			<th>Related Indicator Codes</th>
			<th>CABG</th>
			<th>PCI</th>
			<th>Delete</th>			
		</tr>
	</thead>
	<tbody>		
		<cfloop index="ruleindex" from="1" to="#ArrayLen(local.rules)#" >
			<cfif structKeyExists(local.temprules, "#ruleindex#")>			
				<cfset local.rule = local.rules[ruleindex]>		
				<tr>
					<td>#local.rule.getID()#</td>
					<td><a href="index.cfm?action=rule.form&id=#local.rule.getID()#&way=list">#local.rule.getDesc()#</a></td>
					<td>#local.rule.getComp_char()#</td>
					<td>#local.rule.getComp_ID()#</td>
					<td>#local.rule.getCAGB()#</td>
					<td>#local.rule.getPCI()#</td>					
					<td><a href="index.cfm?action=rule.delete&id=#local.rule.getID()#">DELETE</a></td>
				</tr>
			</cfif>
		</cfloop>
	</tbody>
</table>
</cfoutput>

<a href="index.cfm?action=rule.form">Add new rule?</a>