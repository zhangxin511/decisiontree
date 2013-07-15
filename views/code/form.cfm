<ul class="breadcrumb">
	Your current location:  <li><a href="#">Home</a><span class="divider">/</span></li>
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
<cfset local.available=rc.available>
>
<cfoutput>
	<form class="form-horizontal" method="post" action="index.cfm?action=code.save">
		<cfif local.code.getID()>
			<legend>Edit existing code information</legend>
		<cfelse>
			<legend>Enter new code information</legend>
		</cfif>
		<input type="hidden" name="id" id="id" value="#local.code.getID()#">
		<cfif structKeyExists(rc, "way")>
			<input type="hidden" name="way" id="way" value="#rc.way#">
		</cfif>
		<div class="control-group">
		  	<label for="name" class="control-label">Indicator Name:</label>
		  	<div class="controls">
			  	<input type="text" name="name" id="name" value="#local.code.getName()#" placeholder="Enter Brief Clinical Indicator Title" required>
			</div>
 	
		</div>

  		<div class="control-group">
			<label for="parent_ID" class="control-label">Parent Indicator:</label>
			<div class="controls">
				<select name="parent_ID" id="parent_ID" class="selectpicker show-tick"  data-width="auto" data-size="auto" required>
					<optgroup label="Select root indicator category">
						<option value="0" <cfif local.code.getParent_Id() eq  0>selected="selected"</cfif>>New Root Indicator</option>
					</optgroup>
					<optgroup label="Or, select existing indicator category">
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
			<label for="char_code" class="control-label">Indicator Database Code:</label>
			<div class="controls">
				<input type="text" name="char_code" id="char_code" value="#local.code.getChar_code()#" maxlength="4" placeholder="Enter 1-2 Alphabets Codes" required>
				<span class="help-block">
					<div id="help" name="help"  class="alert alert-info" style="display: none;">
				  		<button type="button" class="close" data-dismiss="alert">&times;</button>
				  		New root codes could be #local.available#.
					</div>
				</span>				
			</div>	 
	  	</div>		
		
		<div class="form-actions">
		  <button type="submit" class="btn btn-primary">Save changes</button>
		  <button type="reset" class="btn">Cancel</button>
		</div>			
	</form>
</cfoutput>

<script src="assets/js/codehelp.js" type="text/javascript"></script>