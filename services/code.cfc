<cfcomponent displayname="CodeService" output="false">
	<!---The new() method--->
	<cffunction name="init" access="public" output="false" returntype="any">

		<cfscript>

		</cfscript>
		<cfreturn this>
	</cffunction>


	<cffunction name="list" access="public" output="false" returntype="struct">
		<cfset local.codes = structNew()>
		<cfquery name="qGetSelection" datasource="#application.dsn#">
			select distinct indecator_ID from tbl_indicator_map 
		</cfquery>	
		
		<cfquery name="qGetCodes" datasource="#application.dsn#">
			select * from tbl_codes where ID in(
			select distinct parent_ID from tbl_codes where id in (
			select distinct code_select from tbl_indicator_map))
			order by ID
		</cfquery>	
				
		<cfscript>
		for (x = 1; x <= qGetCodes.RecordCount; x=x+1) {
			var code = new();
			code.setId(qGetCodes.ID[x]);
			code.setName(qGetCodes.name[x]);
			
			local.codes[code.getId()] = code;
		}	
		local.codes[0] = #qGetSelection.recordCount#;
		</cfscript>		
		<cfreturn local.codes>
    </cffunction>

	<cffunction name="update" access="remote" output="false" returntype="struct">
		<cfargument name="condition" type="string" required="true" />
		<cfset local.codes = structNew()>
		<cfquery name="qGetSelection" datasource="#application.dsn#">
			select distinct indecator_ID, INDECATOR_DESCRIPTIN from tbl_indicator_map where indecator_ID in(
			select indecator_ID from (
				select * 
				from tbl_indicator_map
				where code_select in(select distinct id from tbl_codes where parent_ID in (#arguments.condition#))
			) as a
			
			group by indecator_ID
			having count(indecator_ID)>= #ListLen(arguments.condition)#)
		</cfquery>

		<cfquery name="qGetCodes" datasource="#application.dsn#">
			select * from tbl_codes where ID in
				(select distinct parent_ID from tbl_codes where id in 
					(select distinct code_select from tbl_indicator_map where indecator_ID in (#ValueList(qGetSelection.indecator_ID)#)
					)					
				) and ID not in (#arguments.condition#)
			order by ID
		</cfquery>
					
		<cfscript>
			local.codes[0] = #qGetSelection#;
			local.codes[1]=#qGetCodes#;
		</cfscript>			
		<cfreturn local.codes />
	</cffunction>
		
	<cffunction name="new" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "decisionTree.model.Code").init()>
	</cffunction>	
</cfcomponent>