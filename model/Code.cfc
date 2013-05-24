<cfcomponent displayname="Code" output="false">

	<cfset variables.id = 0 />
	<cfset variables.name = "" />

	<cffunction name="init" access="public" output="false" returntype="Code">
		<cfreturn this />
	</cffunction>

	<cffunction name="setId" access="public" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	<cffunction name="getId" access="public" returntype="string" output="false">
		<cfreturn variables.id />
	</cffunction>

	<cffunction name="setName" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
	</cffunction>
	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn variables.name />
	</cffunction>

</cfcomponent>