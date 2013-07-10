<ul class="breadcrumb">
	Your current location:  <li><a href="#">Home</a><span class="divider">/</span></li>
	<li><a href="#">DST Management</a> <span class="divider">/</span></li>
	<li class="active">Decision Search Tree</li>
</ul>

<cfset local.tempcodes = rc.data>
<cfset local.codes=ArrayNew(1)>

<cfloop collection="#local.tempcodes#" item="local.id">
	<cfif local.id neq 0>	
		<cfset local.codes[local.id] = local.tempcodes[local.id]>
	</cfif>
</cfloop>

<!-- Only required for left/right tabs -->
<cfif #IsDefined("URL.horizon")# and #URL.horizon# eq true> 
	<div class="tabbable" id="code-container0">
<cfelse>
	<div class="tabbable tabs-left" id="code-container0">
</cfif>

	<div class="alert alert-info">
		<span class="text-error">Decision Tab 0:</span> <strong><cfoutput>#local.tempcodes[0]#</cfoutput></strong> indicators found.
	</div>				
			
	<ul class="nav nav-tabs" id="nav0">

		<cfloop index="codeindex" from="1" to="#ArrayLen(local.codes)#" >
			<cfif structKeyExists(local.tempcodes, "#codeindex#")>	
				<cfset local.code = local.codes[codeindex]>	
				<li id="<cfoutput>#local.code.getId()#</cfoutput>0">
					<a href="#tab<cfoutput>#local.code.getId()#</cfoutput>0" data-toggle="tab" <cfif #IsDefined("URL.horizon")# and #URL.horizon# eq true> onclick="collapse(this,true)"<cfelse> onclick="collapse(this,false)"</cfif>>
						<cfoutput>#local.code.getName()#</cfoutput>
					</a>
				</li>					
			</cfif>	
		</cfloop>		
	</ul>	
</div>
<script src="assets/js/collapse.js">>
</script>
