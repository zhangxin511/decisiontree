<ul class="breadcrumb">
	Your current location:  <li class="active"><a href="#">Home</a><span class="divider">/</span></li>
	<li><a href="#">DST Management</a> <span class="divider">/</span></li>
	<li class="active">Add New or Update Existing Rules</li>
</ul>

<cfset local.tempcodes = rc.codes>
<cfset local.codes=ArrayNew(1)>

<cfloop collection="#local.tempcodes#" item="local.id">
	<cfset local.codes[local.id] = local.tempcodes[local.id]>
</cfloop>

<cfset local.rule = rc.rule>
<form class="form-horizontal" method="post" action="index.cfm?action=rule.save">
	<legend>Enter rule information</legend>
	<input type="hidden" name="id" id="id" value="#local.rule.getID()#">
	<div class="control-group">
		<label for="decs" class="control-label">Rule Description:</label>
		<div class="controls">
			<input class="input-xxlarge" type="text" name="desc" id="desc" placeholder="Enter Description for Rule" value="<cfoutput>#local.rule.getDesc()#</cfoutput>">
		</div>	
	</div>
	
	<div class="control-group">
		<label for="char_rule" class="control-label">Rule Selection Code:</label>
		<div class="controls">
			<div class="input-prepend input-append">
			<span class="add-on"><b class="icon-list-alt"></b></span>
			<select id="char_rule" name="char_rule" class="multiselect"  multiple="multiple" >
				<cfloop index="codeindex" from="1" to="#ArrayLen(local.codes)#" >
					<cfif structKeyExists(local.tempcodes, "#codeindex#")>	
						<cfset local.code = local.codes[codeindex]>	
						<optgroup label="<cfoutput>#local.code.getName()#</cfoutput>" class="group" code="<cfoutput>#local.code.getID()#</cfoutput>"></optgroup>		
					</cfif>
				</cfloop>								
		  	</select>
		  	</div>
		</div>				 
  	</div>

	<div class="control-group">
		<label for="CAGB" class="control-label">Treatment:</label>
		<div class="controls controls-row">	
		  	<input id="CAGB" name="CAGB" class="span2" type="text" placeholder="CAGB">
			<input id="PCI" name="PCI" class="span2" type="text" placeholder="PCI">
		</div>
	</div>
	
	<div class="form-actions">
	  <button type="submit" class="btn btn-primary">Save changes</button>
	  <button type="reset" class="btn">Cancel</button>
	</div>
</form>

<script src="assets/js/mliti-select.js"></script>