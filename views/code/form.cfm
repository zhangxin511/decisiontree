<ul class="breadcrumb">
	Your current location:  <li class="active"><a href="#">Home</a><span class="divider">/</span></li>
	<li><a href="#">DST Management</a> <span class="divider">/</span></li>
	<li class="active">Add New or Update Existing Indicators</li>
</ul>
<script type="text/javascript">
	$(window).on('load', function () {
            $('.selectpicker').selectpicker();
        });
</script>
<cfset local.code = rc.code>
<cfset local.parents = rc.parents>
<cfoutput>
	<form class="form-horizontal" method="post" action="index.cfm?action=code.save">
		<legend>Enter code information</legend>
		<input type="hidden" name="id" id="id" value="#local.code.getID()#">
		<cfif structKeyExists(rc, "way")>
			<input type="hidden" name="way" id="way" value="#rc.way#">
		</cfif>
		<div class="control-group">
		  	<label for="name" class="control-label">Indicator Name:</label>
		  	<div class="controls">
			  	<input type="text" name="name" id="name" value="#local.code.getName()#">
			</div>
 	
		</div>
		
		<div class="control-group">
			<label for="char_code" class="control-label">Indicator Database Code:</label>
			<div class="controls">
				<input type="text" name="char_code" id="char_code" value="#local.code.getChar_code()#">
			</div>	 
	  	</div>

  		<div class="control-group">
			<label for="parent_ID" class="control-label">Parent Indicator:</label>
			<div class="controls">
				<select name="parent_ID" id="parent_ID" class="selectpicker show-tick"  data-width="auto" data-size="auto" required>
					<optgroup label="Select the root indicator if it is a category">
						<option value="0" <cfif local.code.getParent_Id() eq  0>selected="selected"</cfif>>Root Indicator</option>
					</optgroup>
					<optgroup label="Or, select one of the category below it belongs to">
						<cfloop collection="#local.parents#" item="local.id">		
							<cfset local.parent = local.parents[local.id]>		
							<!--- when editing a code we need to set the parentcode that user currently has --->
							<cfif local.id EQ local.code.getParent_Id()>
								<option value="#local.id#" selected="selected">#local.parent.getName()#</option>
							<cfelse>
								<option value="#local.id#">#local.parent.getName()#</option>
							</cfif>
			            </cfloop>
		            </optgroup>
				</select>
			</div>
		</div>
		
		<div class="control-group">
			<div class="controls">
				<input type="submit" value="Save Code" class="btn btn-primary">
			</div>
		</div>					
	</form>
</cfoutput>
