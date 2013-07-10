<cfcomponent displayname="Code" output="false">

	<cfset variables.id = 0 />
	<cfset variables.name = "" />
	<cfset variables.parent_ID = "" />
	<cfset variables.char_code = "" />	
	<cfset variables.parent = "" />	
	
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
	

	<cffunction name="setParent_ID" access="public" output="false">
		<cfargument name="parent_ID" type="string" required="true" />
		<cfset variables.parent_ID = arguments.parent_ID />
	</cffunction>
	<cffunction name="getParent_ID" access="public" returntype="string" output="false">
		<cfreturn variables.parent_ID />
	</cffunction>
	

	<cffunction name="setChar_code" access="public" output="false">
		<cfargument name="char_code" type="string" required="true" />
		<cfset variables.char_code = arguments.char_code />
	</cffunction>
	<cffunction name="getChar_code" access="public" returntype="string" output="false">
		<cfreturn variables.char_code />
	</cffunction>		



	<cffunction name="setParent" access="public" output="false">
		<cfargument name="parent" type="any" required="true" />
		<cfset variables.parent = arguments.parent />
	</cffunction>
	<cffunction name="getParent" access="public" returntype="any" output="false">
		<cfreturn variables.parent />
	</cffunction>
</cfcomponent>