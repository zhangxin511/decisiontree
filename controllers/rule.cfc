<cfcomponent displayname="Rule" output="false">
	<cfset variables.fw = "">
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="fw">
		<cfset variables.fw = arguments.fw>
		<cfreturn this>
	</cffunction>

	<cffunction name="setRuleService" access="public" output="false" returntype="void">
		<cfargument name="ruleService" type="any" required="true" />
		<cfset variables.ruleService = arguments.ruleService />
	</cffunction>
	<cffunction name="getRuleService" access="public" output="false" returntype="any">
		<cfreturn variables.ruleService />
	</cffunction>
	
	
	<cffunction name="setCodeService" access="public" output="false">
		<cfargument name="codeService" type="any" required="true" />
		<cfset variables.codeService = arguments.codeService />
	</cffunction>	
	<cffunction name="getCodeService" access="public" returntype="any" output="false">
		<cfreturn variables.codeService />
	</cffunction>	

	<cffunction name="before" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<!--- if the logged on rule is not in the admin role, redirect to main --->
		<cfif session.auth.user.getRoleId() is not 1>
			<cfset rc.message = ['<div class="alert alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button>Sorry, you are NOT authrized to go this function modual!</div>'] />
			<cfset variables.fw.redirect('main','message') />
		</cfif>
	</cffunction>

	<cffunction name="form" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<!--- if the user object does not exist, grab it --->
		<cfif not structkeyexists(rc,'rule')>
			<cfset rc.rule = getRuleService().get(argumentCollection=rc)>
		</cfif>
		<cfset rc.codes = getCodeService().getParentList()>
	</cffunction>

	<cffunction name="startSave" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">

		<cfset var ruleService = getRuleService() />
		<cfset rc.rule = ruleService.get(argumentCollection=rc) />	
		
		<!--- Validate the input error --->
		<cfset rc.message = ruleService.validate(argumentCollection=rc) />	
		<!--- if there were validation errors, grab a blank user to populate and send back to the form --->
		<cfif not arrayIsEmpty(rc.message)>
			<cfset rc.rule = ruleService.new() />
		</cfif>

		<!--- update the user object with the data entered --->
		<cfset variables.fw.populate( cfc = rc.rule, trim = true )>
		<!--- Supply additional information due to the missing form --->
		<cfif #IsDefined("rc.char_rule")#>
			<cfset rc.rule.setComp_ID(#rc.char_rule#)>
			<cfset rc.rule.setComp_char(ruleService.populateComp_char(rc.char_rule))>		
		</cfif>
		<!--- if there were error, redirect the user to the form --->
		<cfif not arrayIsEmpty(rc.message)>
			<cfset variables.fw.redirect('rule.form','rule,message') />
		</cfif>	
		
		
	</cffunction>
		
	<cffunction name="endSave" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<!--- rule saved so by default lets go back to the rule list page --->
		<cfset rc.message = ['<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>Rule <cfoutput>#rc.desc#(#rc.CHAR_RULE#)</cfoutput> was created.</div>'] />
		<cfset variables.fw.redirect("rule.list",'message')>
	</cffunction>	
<!--- 	<cffunction name="endDelete" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">

		<!--- user deleted so by default lets go back to the users list page --->
		<cfset variables.fw.redirect("rule.list")>
	</cffunction>	 --->
</cfcomponent>