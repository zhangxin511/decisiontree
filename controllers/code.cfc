<cfcomponent displayname="Code" output="false">
	<cfset variables.fw = "">
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="fw">
		<cfset variables.fw = arguments.fw>
		<cfreturn this>
	</cffunction>

	<cffunction name="setCodeService" access="public" output="false" returntype="void">
		<cfargument name="codeService" type="any" required="true" />
		<cfset variables.codeService = arguments.codeService />
	</cffunction>
	<cffunction name="getCodeService" access="public" output="false" returntype="any">
		<cfreturn variables.codeService />
	</cffunction>

	<cffunction name="before" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<!--- if the logged on code is not in the admin role, redirect to main --->
		<cfif session.auth.user.getRoleId() is not 1 and session.auth.user.getRoleId() is not 2>
			<cfset rc.message = ['<div class="alert alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button>Sorry, you are NOT authrized to go this function modual!</div>'] />
			<cfset variables.fw.redirect('main','message') />
		</cfif>
	</cffunction>
	
	<cffunction name="form" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<!--- if the logged on code is not in the admin role, redirect to main --->
		<cfif session.auth.user.getRoleId() is not 1>
			<cfset rc.message = ['<div class="alert alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button>Sorry, you are NOT authrized to go this function modual!</div>'] />
			<cfset variables.fw.redirect('main','message') />
		</cfif>		
		<!--- if the user object does not exist, grab it --->
		<cfif not structkeyexists(rc,'code')>
			<cfset rc.code = getCodeService().get(argumentCollection=rc)>
		</cfif>
		<cfset rc.parents = getCodeService().getParentList()>
		<cfset rc.available = getCodeService().getAvailableParentList()>
	</cffunction>

	<cffunction name="startSave" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<cfset var codeService = getCodeService() />

		<cfset rc.code = codeService.get(argumentCollection=rc) />		
		<cfset rc.message = codeService.validate(argumentCollection=rc) />

		<!--- if there were validation errors, grab a blank user to populate and send back to the form --->
		<cfif not arrayIsEmpty(rc.message)>
			<cfset rc.code = codeService.new() />
		</cfif>

		<!--- update the user object with the data entered --->
		<cfset variables.fw.populate( cfc = rc.code, trim = true )>

		<!--- if there were error, redirect the user to the form --->
		<cfif not arrayIsEmpty(rc.message)>
			<cfset variables.fw.redirect('code.form','code,message') />
		</cfif>	
	</cffunction>

	<cffunction name="startList" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<!--- if the logged on code is not in the admin role, redirect to main --->
		<cfif session.auth.user.getRoleId() is not 1>
			<cfset rc.message = ['<div class="alert alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button>Sorry, you are NOT authrized to go this function modual!</div>'] />
			<cfset variables.fw.redirect('main','message') />
		</cfif>	
	</cffunction>
	
	
	<cffunction name="endSave" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<!--- user saved so by default lets go back to the users list page --->
		<cfif structKeyExists(rc, "way") AND (#rc.way# eq "list")>
			<cfset variables.fw.redirect("code.list")>
		<cfelse>
			<cfset variables.fw.redirect("code.listByCategory")>
		</cfif>
	</cffunction>	
<!--- 	<cffunction name="endDelete" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">

		<!--- user deleted so by default lets go back to the users list page --->
		<cfset variables.fw.redirect("code.list")>
	</cffunction>	 --->
</cfcomponent>