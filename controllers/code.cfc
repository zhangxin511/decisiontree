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
			<cfset variables.fw.redirect('main') />
		</cfif>
	</cffunction>
</cfcomponent>