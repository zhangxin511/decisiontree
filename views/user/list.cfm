<ul class="breadcrumb">
	Your current location:  <li><a href="#">Home</a><span class="divider">/</span></li>
	<li><a href="#">User Management</a> <span class="divider">/</span></li>
	<li class="active">list User</li>
</ul>

<cfset local.users = rc.data>
<cfoutput>
<table class="table table-bordered table-striped table-hover table-condense">
	<thead>
		<tr>
			<th>Id</th>
			<th>Name</th>
			<th>Email</th>
			<th>Department</th>
			<th>Role</th>
			<th>Reset Password</th>
			<th>Delete</th>
		</tr>
	</thead>
	<tbody>
		<cfif structCount(local.users) EQ 0>
			<tr><td colspan="6">No users exist but <a href="index.cfm?action=user.form">new ones can be added</a>.</td></tr>
		</cfif>
		<cfloop collection="#local.users#" item="local.id">
			
			<cfset local.user = local.users[local.id]>
			
			<tr>
				<td>#local.id#</td>
				<td><a href="index.cfm?action=user.form&id=#local.id#">#local.user.getFirstName()# #local.user.getLastName()#</a></td>
				<td>#local.user.getEmail()#</td>
				<td>#local.user.getDepartment().getName()#</td>
				<td>#local.user.getRole().getName()#</td>
				<td><a href="index.cfm?action=user.resetPass&id=#local.id#">RESET</a></td>
				<td><a href="index.cfm?action=user.delete&id=#local.id#">DELETE</a></td>
			</tr>
		</cfloop>
	</tbody>
</table>
</cfoutput>