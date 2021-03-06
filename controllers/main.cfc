﻿<cfcomponent>
	<cfset variables.fw = '' />
	<cffunction name="init" access="public" returntype="void">
		<cfargument name="fw" type="any" required="yes" />
		<cfset variables.fw = arguments.fw />
	</cffunction>

	<cffunction name="setUserService" access="public" output="false" returntype="void">
		<cfargument name="userService" type="any" required="true" />
		<cfset variables.userService = arguments.userService />
	</cffunction>
	<cffunction name="getUserService" access="public" output="false" returntype="any">
		<cfreturn variables.userService />
	</cffunction>

	<cffunction name="password" access="public" returntype="void">
		<cfargument name="rc" type="struct" required="yes" />
				
		<cfset rc.user = getUserService().get(session.auth.user.getId()) />
	</cffunction>

	<cffunction name="change" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		
		<cfset var userService = getUserService() />
		<cfset var newPasswordHash = '' />

		<cfif (not isDefined("rc.id")) or (rc.id neq session.auth.user.getId())>
			<cfset rc.message = ['<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>You do not have previliege to change others password.</div>'] />
			<cfset variables.fw.redirect('main','message') />		
		</cfif>
		
		<!--- validate new password --->
		<cfset rc.user = userService.get(argumentCollection=rc) />
		<cfset rc.message = userService.checkPassword(argumentCollection=rc) />
		
		<!--- if the new password failed, redirect to the form --->
 		<cfif not arrayIsEmpty(rc.message)>
			<cfset variables.fw.redirect('main.password','message') />
		</cfif>

		<!--- hash the new password and populate the user object --->
		<cfset newPasswordHash = userService.hashPassword(rc.newPassword) />
		<cfset rc.passwordHash = newPasswordHash.hash />
		<cfset rc.passwordSalt = newPasswordHash.salt />
		<cfset variables.fw.populate( cfc = rc.user, trim = true )>

		<!--- save the user and redirect --->
		<cfset userService.save(rc.user) />
		<cfset rc.message = ['<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>Your password was changed.</div>'] />
		<cfset variables.fw.redirect('main','message') />
	</cffunction>

</cfcomponent>