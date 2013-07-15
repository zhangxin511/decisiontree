<cfcomponent displayname="Rule" output="false">

	<cfset variables.id = 0 />
	<cfset variables.desc = "" />
	<cfset variables.comp_ID = "" />
	<cfset variables.comp_char = "" />	
	<cfset variables.CABG = "" />	
	<cfset variables.pci = "" />
		
	<cffunction name="init" access="public" output="false" returntype="Rule">
		<cfreturn this />
	</cffunction>

	<cffunction name="setId" access="public" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	<cffunction name="getId" access="public" returntype="string" output="false">
		<cfreturn variables.id />
	</cffunction>

	<cffunction name="setDesc" access="public" output="false">
		<cfargument name="desc" type="string" required="true" />
		<cfset variables.desc = arguments.desc />
	</cffunction>
	<cffunction name="getDesc" access="public" returntype="string" output="false">
		<cfreturn variables.desc />
	</cffunction>
	

	<cffunction name="setComp_ID" access="public" output="false">
		<cfargument name="comp_ID" type="string" required="true" />
		<cfset variables.comp_ID = arguments.comp_ID />
	</cffunction>
	<cffunction name="getComp_ID" access="public" returntype="string" output="false">
		<cfreturn variables.comp_ID />
	</cffunction>
	

	<cffunction name="setComp_char" access="public" output="false">
		<cfargument name="comp_char" type="string" required="true" />
		<cfset variables.comp_char = arguments.comp_char />
	</cffunction>
	<cffunction name="getComp_char" access="public" returntype="string" output="false">
		<cfreturn variables.comp_char />
	</cffunction>		


	<cffunction name="setCABG" access="public" output="false">
		<cfargument name="CABG" type="string" required="true" />
		<cfset variables.CABG = arguments.CABG />
	</cffunction>
	<cffunction name="getCABG" access="public" returntype="string" output="false">
		<cfreturn variables.CABG />
	</cffunction>
	
	<cffunction name="setPci" access="public" output="false">
		<cfargument name="pci" type="string" required="true" />
		<cfset variables.pci = arguments.pci />
	</cffunction>
	<cffunction name="getPci" access="public" returntype="string" output="false">
		<cfreturn variables.pci />
	</cffunction>
	
</cfcomponent>