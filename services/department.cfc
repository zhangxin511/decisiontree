<cfcomponent displayname="DepartmentService" output="false">
	
	<cfset variables.departments = structNew()>
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfquery name="qGetDepartments" datasource="#application.dsn#">
			select * from tbl_departments
		</cfquery>		
		<cfscript>
		var dept = "";
		
		// since services are cached, user data well be persisted
		// ideally, this would be saved elsewhere, e.g. database
		for (x = 1; x <= qGetDepartments.RecordCount; x=x+1) {
			dept = new();
			dept.setId(qGetDepartments.ID[x]);
			dept.setName(qGetDepartments.name[x]);
	
			variables.departments[dept.getId()] = dept;
		}
		</cfscript>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" output="false" returntype="any">
		<cfargument name="id" type="string" required="true">
		
		<cfset var result = "">
		
		<cfif len(id) AND structKeyExists(variables.departments, id)>
			<cfset result = variables.departments[id]>
		<cfelse>
			<cfset result = new()>
		</cfif>
		
		<cfreturn result>
	</cffunction>
	
	<cffunction name="list" access="public" output="false" returntype="struct">
		<cfreturn variables.departments>
    </cffunction>
	
	<cffunction name="new" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "decisionTree.model.Department").init()>
	</cffunction>
	
</cfcomponent>