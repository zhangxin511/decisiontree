<cfset local.codes = rc.data />
<cfif structCount(local.codes) EQ 1>
	<!--- Should not happen --->
	<div class="alert alert-error">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		<strong>Error!</strong> Now such available selections.
	</div>
<cfelse>
	<div class="alert alert-info">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		Totally <strong><cfoutput>#local.codes[0]#</cfoutput></strong> records, please select one of the rest categories below to reduce numbers.
	</div>	
	<!-- Only required for left/right tabs -->
	<div class="tabbable" id="code-container0">		
		<ul class="nav nav-tabs" id="nav0">
			<cfloop collection="#local.codes#" item="local.id">
				<cfif local.id neq 0>				
					<cfset local.code = local.codes[local.id]>
					<li id="<cfoutput>#local.code.getId()#</cfoutput>0">
						<a href="#tab<cfoutput>#local.code.getId()#</cfoutput>0" data-toggle="tab" onclick="collapse(this)">
							<cfoutput>#local.code.getName()#</cfoutput>
						</a>
					</li>					
				</cfif>
			</cfloop>		
		</ul>		
	</div>
	
</cfif>

<script src="assets/js/collapse.js">>
</script>
