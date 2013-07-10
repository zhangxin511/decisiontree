<cfcomponent displayname="UserService" output="false">
	<cfset variables.users = structNew()>
	<!---The new() method--->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="departmentService" type="any" required="true" />
		<cfargument name="roleService" type="any" required="true" />
		<cfargument name="passService" type="any" required="true" />			
		<cfscript>
			setDepartmentService(arguments.departmentService);
			setRoleService(arguments.roleService);
			setPassService(arguments.passService);
			list();
		</cfscript>
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
	
	<cffunction name="delete" access="public" output="false" returntype="boolean">
		<cfargument name="id" type="string" required="true">
		<cflock type="exclusive" name="deleteuser" timeout="50" throwontimeout="false">
			<!--- since we have an id we are updating a user --->
			<cfquery name="deleteUser" datasource="#application.dsn#">
				delete 
				from tbl_users
				where id=#arguments.id#
			</cfquery>
		</cflock>
		<cfreturn true>
	</cffunction>

	<cffunction name="get" access="public" output="false" returntype="any">
		<cfargument name="id" type="string" required="false" default="">
		<cfset var result = "">
		<cfif len(id) AND structKeyExists(variables.users, id)>
			<cfset result = variables.users[id]>
		<cfelse>
			<cfset result = new()>
		</cfif>
		
		<cfreturn result>
	</cffunction>

	<cffunction name="getByEmail" access="public" returntype="any">
		<cfargument name="email" type="string" required="false" default="">
		<cfset var result = "">
		<cfif len(email)>
			<cfquery name="getUserbyName" datasource="#Application.DSN#">
				select * from tbl_users where email='#arguments.email#'
			</cfquery>
		</cfif>
		
		<cfif #getUserbyName.recordCount# eq 0 >
			<!--- if there is no user with a matching email address, return a blank user --->
			<cfset result = new()>
		<cfelse>
			<cfscript>
				var result=new();
				result.setId(getUserbyName.ID[1]);
				result.setFirstName(getUserbyName.first_name[1]);
				result.setLastName(getUserbyName.last_name[1]);
				result.setEmail(getUserbyName.email[1]);
				result.setDepartmentId(getUserbyName.departmentID[1]);
				result.setDepartment(getDepartmentService().get(getUserbyName.departmentID[1]));
				result.setRoleId(getUserbyName.roleID[1]);
				result.setRole(getRoleService().get(getUserbyName.roleID[1]));
				result.setPasswordHash(getUserbyName.password_hash[1]);
				result.setPasswordSalt(getUserbyName.password_salt[1]);	
			</cfscript>	
		</cfif>
		
		<cfreturn result>
	</cffunction>

	<cffunction name="list" access="public" output="false" returntype="struct">
		<cfset local.users = structNew()>
		<cfquery name="qGetUsers" datasource="#application.dsn#">
			select * from tbl_users
		</cfquery>	
		<cfscript>
			for (x = 1; x <= qGetUsers.RecordCount; x=x+1) {
				var user = new();
				user.setId(qGetUsers.ID[x]);
				user.setFirstName(qGetUsers.first_name[x]);
				user.setLastName(qGetUsers.last_name[x]);
				user.setEmail(qGetUsers.email[x]);
				user.setDepartmentId(qGetUsers.departmentID[x]);
				user.setDepartment(getDepartmentService().get(qGetUsers.departmentID[x]));
				user.setRoleId(qGetUsers.roleID[x]);
				user.setRole(getRoleService().get(qGetUsers.roleID[x]));
				user.setPasswordHash(qGetUsers.password_hash[x]);
				user.setPasswordSalt(qGetUsers.password_salt[x]);
				
				local.users[user.getId()] = user;
				variables.users[user.getId()] = user;
			}	
		</cfscript>	
		
		<cfreturn local.users>
    </cffunction>

	<cffunction name="new" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "decisionTree.model.User").init()>
	</cffunction>

	<cffunction name="validate" access="public" output="true" returntype="Array">
		<cfargument name="user" type="any" required="true" />
		<cfargument name="firstName" type="string" required="false" default="" />
		<cfargument name="lastName" type="string" required="false" default="" />
		<cfargument name="email" type="string" required="false" default="" />
		<cfargument name="departmentId" type="string" required="false" default="" />
		<cfargument name="roleId" type="string" required="false" default="" />
		<cfargument name="password" type="string" required="false" default="" />

		<cfset var aErrors = arrayNew(1) />
		<!--- check to see if a user exists with the email address --->
		<cfset var userByEmail = getByEmail(arguments.email) />
		<!--- check to see if the department selected matches a department record --->
		<cfset var department = getDepartmentService().get(arguments.departmentId) />
		<!--- check to see if the role selected matches a role record --->
		<cfset var role = getRoleService().get(arguments.roleId) />

		<!--- first name is required --->
		<cfif not len(arguments.user.getFirstName()) and not len(arguments.firstName)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter the user first name!</div>') />
		</cfif>

		<!--- last name is required --->
		<cfif not len(arguments.user.getLastName()) and not len(arguments.lastName)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter the user last name!</div>') />
		</cfif>

		<!--- email address is required --->
		<cfif not len(arguments.user.getEmail()) and not len(arguments.email)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter the user email address!</div>') />
		<!--- verify the email is a valid format --->
		<cfelseif len(arguments.email) and not isEmail(arguments.email)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter a valid email address!</div>') />
		<!--- verify the email address is unique for this user, only for new user --->
		<cfelseif len(arguments.email) and compare(arguments.email,arguments.user.getEmail()) and userByEmail.getId()>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>A user already exists with this email address, please enter a new address!</div>') />
		</cfif>

		<!--- department id is required, must be numeric and match a department record --->
		<cfif not len(arguments.departmentId) or not isnumeric(arguments.departmentId) or not department.getId()>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please select a department!</div>') />
		</cfif>

		<!--- role id is required, must be numeric and match a role record --->
		<cfif not len(arguments.roleId) or not isnumeric(arguments.roleId) or not role.getId()>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please select a role!</div>') />
		</cfif>

		<cfreturn aErrors />
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">		
		<cfargument name="user" type="any" required="true">
		<cflock type="exclusive" name="saveuser" timeout="50" throwontimeout="false">
			<!--- since we have an id we are updating a user --->
			<cfif arguments.user.getId()>
				<cfquery name="updateuserinfo" datasource="#application.dsn#">
					update  tbl_users
					set first_name='#arguments.user.getFirstName()#',
						last_name='#arguments.user.getLastname()#',
						email='#arguments.user.getEmail()#',
						departmentID= '#arguments.user.getDepartmentid()#', 
						roleID='#arguments.user.getRoleid()#',
						password_hash='#arguments.user.getPasswordHash()#',
						password_salt='#arguments.user.getPasswordSalt()#'
					where id=#arguments.user.getId()#
				</cfquery>
			<cfelse>
			<!--- otherwise a new user is being saved --->
				<cfquery name="saveuserinfo" datasource="#application.dsn#">
					insert into  tbl_users  (first_name, last_name, email,departmentID,roleID,password_hash,password_salt)
					VALUES ('#arguments.user.getFirstname()#', '#arguments.user.getLastname()#', '#arguments.user.getEmail()#', '#arguments.user.getDepartmentid()#', '#arguments.user.getRoleid()#', '#arguments.user.getPasswordHash()#', '#arguments.user.getPasswordSalt()#');
				</cfquery>		
			</cfif>
		</cflock>
	</cffunction>

	<cffunction name="hashPassword" access="public" output="false" returntype="struct">
		<cfargument name="password" type="string" required="true" hint="Pass in password" />
		<!--- At this point the function assumes that you have already validated the
			password as meeting application requirements --->
		<cfset var returnVar = structNew() />
		<cfset var passwordHash = "" />

		<!--- Salt the password --->
		<cfset var salt = createUUID() />

		<cfset passwordHash = hash(arguments.password & salt, 'SHA-512') />

		<cfset returnVar.hash = passwordHash />
		<cfset returnVar.salt = salt />

		<cfreturn returnVar />
	</cffunction>

	<cffunction name="validatePassword" access="public" output="no" returntype="boolean">
		<cfargument name="user" required="yes" type="any" />
		<cfargument name="password" required="yes" type="string" />
		<cfset var validPass = false />

		<!--- Set the input hash by concatenating the password that was passed in to the salt
			and hashing it with the same hash function as when it was stored. --->
		<cfset var inputHash = hash(trim(arguments.password) & trim(arguments.user.getPasswordSalt()), 'SHA-512') />

		<!--- Compare the inputHash with the hash we pulled from the db if they match,
			then the correct password was passed in --->
		<cfif not compare(inputHash, arguments.user.getPasswordHash())>
			<cfset validPass = true />
		</cfif>
		<cfreturn validPass />
	</cffunction>


	<cffunction name="checkPassword" access="public" output="no" returntype="array"
    	hint="I check password strength and determine if it is up to snuff, I return an array of error messages">
		<cfargument name="user" type="any" required="true">
		<cfargument name="currentPassword" type="string" required="no" default=""
			hint="Send in current user's password for validation when user is changing password" />
		<cfargument name="newPassword" required="no" default="" type="string"
			hint="Send in password1 as a string, default is a blank string, which will fail" />
		<cfargument name="retypePassword" required="no" default="" type="string"
			hint="Send in password2 as a string, default is a blank string, which will fail" />

		<cfscript>
		// Initialize return variable
		var aErrors = arrayNew(1);
		var inputHash = '';
		var count = 0;

		// if the password fields to not have values, add an error and return
		if (not len(arguments.newPassword) or not len(arguments.retypePassword)) {
			arrayAppend(aErrors, '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please fill out all form fields!</div>');
			return aErrors;
		}

		if (len(arguments.currentPassword) and isObject(user)) {
	
			/* Compare the inputHash with the hash in the user object. if they do not match,
				then the correct password was not passed in */
			if (not this.validatePassword(user,arguments.currentPassword)) {
				arrayAppend(aErrors, '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Your password in our database does NOT match the current password entered!</div>');
				// Return now, there is no point testing further
				return aErrors;
			}
		}

		// Check the password rules
		// *** to change the strength of the password required, uncomment as needed

		// Check to see if the two passwords match
		if (not compare(arguments.newPassword, arguments.retypePassword) IS 0) {
			arrayAppend(aErrors, '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>The new passwords you entered do not match!</div>');
			// Return now, there is no point testing further
			return aErrors;
		}

		// If the password is more than X and less than Y, add an error.
		if (len(arguments.newPassword) LT 8)// OR Len(arguments.newPassword) GT 25
			arrayAppend(aErrors, '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Your password must be at least 8 characters long!</div>');// between 8 and 25
		</cfscript>

		<!--- return the array of errors --->
		<cfreturn aErrors />
	</cffunction>

<cfscript>
/**
* Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
* Update by David Kearns to support '
* SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
* Should support + gmail style addresses now.
* More TLDs
* Version 4 by P Farrel, supports limits on u/h
* Added mobi
* v6 more tlds
*
* @param str      The string to check. (Required)
* @return Returns a boolean.
* @author Jeff Guillaume (SBrown@xacting.comjeff@kazoomis.com)
* @version 7, May 8, 2009
*/
function isEmail(str) {
return (REFindNoCase("^['_a-z0-9-\+]+(\.['_a-z0-9-\+]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$",
arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
}
</cfscript>

</cfcomponent>