<div class="row">
	<div class="alert alert-success span6">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		Welcome, <cfoutput>#session.auth.fullname#! </cfoutput>
		<cfset hour=#hour(now())#>
		<cfif (#hour# gte 20) or (#hour# lte 6) >
			It is rest time, do not work so hard!
		<cfelseif (#hour# gt 6) and (#hour# lte 12 )>
			Have a great day!
		<cfelse>
			Have a good one, enjoy a cup of coffee!
		</cfif>
			
	</div>
</div>
<cfif structKeyExists(rc, "reload")>
	<p>The framework cache (and application scope) have been reset.</p>
</cfif>