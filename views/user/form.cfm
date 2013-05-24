<cfset local.user = rc.user>
<cfset local.depts = rc.departments>
<cfset local.roles = rc.roles>

<cfoutput>
	<form class="form-horizontal" method="post" action="index.cfm?action=user.save">
		<legend>Enter user information</legend>
		<div class="control-group">
		  	<label for="firstName" class="control-label">First Name:</label>
		  	<div class="controls">
			  	<input type="text" name="firstName" id="firstName" value="#local.user.getFirstName()#">
			</div>
	
			<label for="lastName" class="control-label">Last Name:</label>
			<div class="controls">
				<input type="text" name="lastName" id="lastName" value="#local.user.getLastName()#">
			</div>	  	
		</div>
		
		<div class="control-group">
			<label for="email" class="control-label" required>Email:</label>	
	    	<div class="controls">
		    	<input type="text" name="email" id="email" value="#local.user.getEmail()#" required>
	    	</div>
	  	</div>
	  	
		<div class="control-group">
			<label for="departmentId" class="control-label">Department:</label>
			<div class="controls">
				<select name="departmentId" id="departmentId" required>
					<cfloop collection="#local.depts#" item="local.id">		
						<cfset local.dept = local.depts[local.id]>		
						<!--- when editing a user we need to set the dept that user currently has --->
						<cfif local.id EQ local.user.getDepartmentId()>
							<option value="#local.id#" selected="selected">#local.dept.getName()#</option>
						<cfelse>
							<option value="#local.id#">#local.dept.getName()#</option>
						</cfif>
		            </cfloop>
				</select>
			</div>
		</div>
		
		<div class="control-group">
			<label for="roleId" class="control-label">Role:</label>
			<div class="controls">
				<select name="roleId" id="roleId"  required>
					<cfloop collection="#local.roles#" item="local.id">
		
						<cfset local.role = local.roles[local.id]>
		
						<!--- when editing a user we need to set the role that user currently has --->
						<cfif local.id EQ local.user.getRoleId()>
							<option value="#local.id#" selected="selected">#local.role.getName()#</option>
						<cfelse>
							<option value="#local.id#">#local.role.getName()#</option>
						</cfif>
		      		</cfloop>
				</select>
			</div>
		</div>	
		
		<cfif not local.user.getId()>
			<div class="control-group">
				<label for="password" class="control-label">Password:</label>
				<div class="controls">
					<input type="text" name="password" id="password" required>
				</div>
			</div>
		</cfif>
		
		 <div class="control-group">
			 <div class="controls">
				 <input type="submit" value="Save User" class="btn btn-primary">
			 </div>
		 </div>					
	</form>
</cfoutput>