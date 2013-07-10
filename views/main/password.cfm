<ul class="breadcrumb">
	Your current location:  <li><a href="#">Home</a><span class="divider">/</span></li>
	<li><a href="#">User Management</a> <span class="divider">/</span></li>
	<li class="active">Change password</li>
</ul>
<cfset local.user = rc.user />

<cfoutput>
	<form name="userForm" id="userForm" class="form-horizontal" method="post" action="index.cfm?action=main.change">
		<legend>Change password</legend>
		<input type="hidden" name="id" value="#local.user.getId()#">
		<div class="control-group">
		  	<label for="currentPassword" class="control-label">Current Password:</label>
		  	<div class="controls">
			  	<input type="password" name="currentPassword" id="currentPassword" required>
			</div>
		</div>
		
		<div class="control-group">
			<label for="newPassword" class="control-label">New Password:</label>
			<div class="controls">
				<input type="password" name="newPassword" id="newPassword" required>
			</div>	 
			
			<label for="retypePassword" class="control-label">Retype Password:</label>
			<div class="controls">
				<input type="password" name="retypePassword" id="retypePassword" required>
			</div>				 	
		</div>
		
		 <div class="control-group">
			 <div class="controls">
				 <input type="submit" value="Change Password" class="btn btn-primary">
			 </div>
		 </div>					
	</form>
	<p><strong>Your New Password:</strong></p>
	<ol>
		<li>Can not match your current password</li>
		<li>Must be at least 8 characters long</li>
		<li>Is case sensitive</li>
	</ol>	
</cfoutput>
