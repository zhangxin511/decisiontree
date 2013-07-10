<ul class="breadcrumb">
	Your current location:  <li><a href="#">Home</a><span class="divider">/</span></li>
	<li><a href="#">DST Management</a> <span class="divider">/</span></li>
	<li class="active">Angiographic and Clinical Indicators (By Category)</li>
</ul>
<cfset local.tempcodes = rc.data>
<cfset local.codes=ArrayNew(1)>

<cfloop collection="#local.tempcodes#" item="local.id">
	<cfset local.codes[local.id] = local.tempcodes[local.id]>
</cfloop>

<div class="accordion" id="accordion2">
	<cfloop index="codeindex" from="1" to="#ArrayLen(local.codes)#" >
		<cfif structKeyExists(local.tempcodes, "#codeindex#")>			
			<cfset local.code = local.codes[codeindex]>		
			<div class="accordion-group">
		    	<div class="accordion-heading">
		      		<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapse<cfoutput>#local.code.getID()#</cfoutput>">
		        		<strong><cfoutput>#local.code.getChar_Code()#. #local.code.getName()#</cfoutput></strong>
		      		</a>
		      		
		     	</div>
			    <div id="collapse<cfoutput>#local.code.getID()#</cfoutput>" class="accordion-body collapse">
			    	<div id="inner<cfoutput>#local.code.getID()#</cfoutput>" class="accordion-inner" code="<cfoutput>#local.code.getID()#</cfoutput>">
			        	
			      	</div>
			    </div>	    	
		  	</div>
		</cfif>
	</cfloop>
</div>
<!--- 
<div class="tabbable tabs-left">
	<ul class="nav nav-tabs">
		<cfloop index="codeindex" from="1" to="#ArrayLen(local.codes)#" >	
			<cfif structKeyExists(local.tempcodes, "#codeindex#")>		
				<cfset local.code = local.codes[codeindex]>		
				<li>
					<a href="#tab<cfoutput>#local.code.getId()#</cfoutput>" data-toggle="tab">
						<cfoutput>#local.code.getChar_Code()#. #local.code.getName()#</cfoutput>
					</a>		
				</li>
			</cfif>
		</cfloop>	
	</ul>
	<div class="tab-content">
		<cfloop index="codeindex" from="1" to="#ArrayLen(local.codes)#" >	
			<cfif structKeyExists(local.tempcodes, "#codeindex#")>		
				<cfset local.code = local.codes[codeindex]>		
				<div class="tab-pane" id="tab<cfoutput>#local.code.getID()#</cfoutput>">
	
		    	</div> 
	    	</cfif> 
		</cfloop>	 
	</div>
</div>		
	 --->
<script src="assets/js/collapselist.js"></script>
<a href="index.cfm?action=code.form">Add new code?</a>