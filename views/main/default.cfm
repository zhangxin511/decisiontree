<ul class="breadcrumb">
	Your current location:  <li class="active"><a href="#">Home</a></li>
</ul>

<div class="alert alert-success">
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
	<br/>Please note: Your session will expire after 30 minutes of inactivity.
</div>
