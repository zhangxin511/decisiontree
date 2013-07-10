<cfcomponent displayname="User" output="false">
	<cfset variables.fw = "">
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="fw">
		<cfset variables.fw = arguments.fw>
		<cfreturn this>
	</cffunction>

	<cffunction name="setDepartmentService" access="public" output="false">
		<cfargument name="departmentService" type="any" required="true" />
		<cfset variables.departmentService = arguments.departmentService />
	</cffunction>
	<cffunction name="getDepartmentService" access="public" returntype="any" output="false">
		<cfreturn variables.departmentService />
	</cffunction>
	
	<cffunction name="setPassService" access="public" output="false">
		<cfargument name="passService" type="any" required="true" />
		<cfset variables.passService = arguments.passService />
	</cffunction>	
	<cffunction name="getPassService" access="public" returntype="any" output="false">
		<cfreturn variables.passService />
	</cffunction>	

	<cffunction name="setRoleService" access="public" output="false">
		<cfargument name="roleService" type="any" required="true" />
		<cfset variables.roleService = arguments.roleService />
	</cffunction>
	<cffunction name="getRoleService" access="public" returntype="any" output="false">
		<cfreturn variables.roleService />
	</cffunction>

	<cffunction name="setUserService" access="public" output="false" returntype="void">
		<cfargument name="userService" type="any" required="true" />
		<cfset variables.userService = arguments.userService />
	</cffunction>
	<cffunction name="getUserService" access="public" output="false" returntype="any">
		<cfreturn variables.userService />
	</cffunction>

	<cffunction name="before" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<!--- if the logged on user is not in the admin role, redirect to main --->
		<cfif session.auth.user.getRoleId() is not 1>
			<cfset rc.message = ['<div class="alert alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button>Sorry, you are NOT authrized to go this function modual!</div>'] />
			<cfset variables.fw.redirect('main','message') />
		</cfif>
	</cffunction>

	<cffunction name="form" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		
		<!--- if the user object does not exist, grab it --->
		<cfif not structkeyexists(rc,'user')>
			<cfset rc.user = getUserService().get(argumentCollection=rc)>
		</cfif>

		<!--- we need to retrieve all access levels and roles for the drop down selection --->
		<cfset rc.departments = getDepartmentService().list()>
		<cfset rc.roles = getRoleService().list()>
	</cffunction>

	<cffunction name="startSave" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<cfset var userService = getUserService() />
		<cfset var newpasshash = '' />
		
		<!--- validate the user --->		
		<cfset rc.user = userService.get(argumentCollection=rc) />	
		
		<cfif #rc.user.getId()# eq 0>
			<cfscript>
				StructInsert(rc, "password", getPassService().generatePass());			
			</cfscript>
		</cfif>

		<cfset rc.message = userService.validate(argumentCollection=rc) />

		<!--- if there were validation errors, grab a blank user to populate and send back to the form --->
		<cfif not arrayIsEmpty(rc.message)>
			<cfset rc.user = userService.new() />
		</cfif>

		<!--- update the user object with the data entered --->
		<cfset variables.fw.populate( cfc = rc.user, trim = true )>

		<!--- if there were error, redirect the user to the form --->
		<cfif not arrayIsEmpty(rc.message)>
			<cfset variables.fw.redirect('user.form','user,message') />
		</cfif>

		<!--- update the user object with the new selection --->
		<cfif structKeyExists(rc, "departmentId") AND len(rc.departmentId)>
			<cfset rc.user.setDepartmentId(rc.departmentId)>
			<cfset rc.user.setDepartment(getDepartmentService().get(rc.departmentId))>
		</cfif>

						
		<!--- if the password is new, update the user object with the password hash and salt --->
		<cfif structKeyExists(rc, "password") AND len(rc.password)>
			<cfset newpasshash = userService.hashPassword(rc.password) />
			<cfset rc.user.setPasswordHash(newpasshash.hash) />
			<cfset rc.user.setPasswordSalt(newpasshash.salt) />
		</cfif>

	</cffunction>

	
	
	<cffunction name="resetPass" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		

		<cfset var userService = getUserService() />
		<cfset var newpasshash = '' />
		
		<!--- validate the user --->		
		<cfset rc.user = userService.get(argumentCollection=rc) />	

		<cfscript>
			StructInsert(rc, "password", getPassService().generatePass());			
		</cfscript>

		<!--- hash the new password and populate the user object --->
		<cfset newPasswordHash = userService.hashPassword(rc.password) />
		<cfset rc.passwordHash = newPasswordHash.hash />
		<cfset rc.passwordSalt = newPasswordHash.salt />
		<cfset variables.fw.populate( cfc = rc.user, trim = true )>

		<!--- save the user and redirect --->
		<cfset userService.save(rc.user) />
		<cfset sendResetEmail(argumentCollection=rc)/>
		<cfset rc.message = ['<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>Password has reset for <cfoutput>#rc.user.getFirstName()# #rc.user.getLastName()#</cfoutput></div>'] />
		<cfset variables.fw.redirect('user.list','message') />

	</cffunction>

	<cffunction name="sendResetEmail" access="public" output="true" returntype="void">
		<cfargument name="user" type="struct" required="true">
		<cfargument name="password" type="string" required="true">
		<!--- Create email subject --->
        <cfset subject = "Omar Study: User login information reset"> 
		<!--- Create email title --->
		<cfoutput>
		    <CFMAIL type="html" 
		        to="#user.getEmail()#"
		        cc="xzhan64@emory.edu" 
		        replyto="xzhan64@emory.edu"
		        server="smtp.sph.emory.edu"  
		        from="xzhan64@emory.edu" subject="#subject#" >
		    
		            Dear #user.getFirstName()#,#user.getLastName()#
		            <p>
		            	You account for Omar website has been reset. <br/>
		                Log in email: <u>#user.getEmail()#</u><br/>Temporary password: <u>#arguments.password#</u>
		            </p>
		            
		            <p>
		            	Please log on Omar website at <a href="https://cfusion.sph.emory.edu/bmi/decisiontree/index.cfm">https://cfusion.sph.emory.edu/bmi/decisiontree/index.cfm</a> to Log in. When you log in, you can change the password. You can enter new password that you want to use.  Then save. Your password will reset to new password you just entered. For all subsequent data entries, you will use your username and your new password that you just created.
		            </p>
		            <p>Please do NOT share your login information with others.
		            <p>
		            	Thanks!
		            </p>
		            
		            
		            <p>
		            Xin (John) Zhang<br/>
		            Software Engineer<br/>
		            Cholera website programmer<br/>
		            Department of Biostatistics & Bioinformatics,<br/>
		            Emory University, Atlanta, GA<br/>
		            Office Tel: 404 727 8128
		            </p>
		    </CFMAIL>
		</cfoutput>   	
	</cffunction>
		
	<cffunction name="endSave" access="public" output="true" returntype="void">
		<cfargument name="rc" type="struct" required="true">

		<!--- Create email subject --->
        <cfset subject = "Omar Study: New user login information"> 
		<!--- Create email title --->
		<cfoutput>
		    <CFMAIL type="html" 
		        to="#rc.email#"
		        cc="xzhan64@emory.edu" 
		        replyto="xzhan64@emory.edu"
		        server="smtp.sph.emory.edu"  
		        from="xzhan64@emory.edu" subject="#subject#" >
		    
		            Dear #rc.firstname# #rc.lastname#
		            <p>
		            	You account for Omar website has been created. <br/>
		                Log in email: <u>#rc.email#</u><br/>Temporary password: <u>#rc.password#</u>
		            </p>
		            
		            <p>
		            	Please log on Omar website at <a href="https://cfusion.sph.emory.edu/bmi/decisiontree/index.cfm">https://cfusion.sph.emory.edu/bmi/decisiontree/index.cfm</a> to Log in. When you log in, you can change the password. You can enter new password that you want to use.  Then save. Your password will reset to new password you just entered. For all subsequent data entries, you will use your username and your new password that you just created.
		            </p>
		            <p>Please do NOT share your login information with others.
		            <p>
		            	Thanks!
		            </p>
		            
		            
		            <p>
		            Xin (John) Zhang<br/>
		            Software Engineer<br/>
		            Cholera website programmer<br/>
		            Department of Biostatistics & Bioinformatics,<br/>
		            Emory University, Atlanta, GA<br/>
		            Office Tel: 404 727 8128
		            </p>
		    </CFMAIL>
		</cfoutput>   
		
		<!--- user saved so by default lets go back to the users list page --->
		<cfset rc.message = ['<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>User <cfoutput>#rc.firstname# #rc.lastname#</cfoutput> was created.</div>'] />
		<cfset variables.fw.redirect("user.list",'message')>
		
	</cffunction>

	<cffunction name="endDelete" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">

		<!--- user deleted so by default lets go back to the users list page --->
		<cfset rc.message = ['<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>User was deleted.</div>'] />
		<cfset variables.fw.redirect("user.list",'message')>
	</cffunction>

</cfcomponent>