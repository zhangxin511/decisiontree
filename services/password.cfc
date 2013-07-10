<cfcomponent displayname="PassService" output="false">

	<cfproperty name="strAllValidChars" type="string" />
	<cfproperty name="strLowerCaseAlpha" type="string" />
	<cfproperty name="strUpperCaseAlpha" type="string" />
	<cfproperty name="strNumbers" type="string" />
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<!--- Set up available lower case values. --->
		<cfset strLowerCaseAlpha = "abcdefghjkmnpqrstuvwxyz" />	
		<!--- Set up available upper case values. --->
		<cfset strUpperCaseAlpha = UCase( strLowerCaseAlpha ) />
		<!--- Set up available numbers. --->
		<cfset strNumbers = "23456789" />			
		<!---
		When selecting random value, we want to be able to easily
		choose from the entire set. To this effect, we are going
		to concatenate all the previous valid character sets.
		--->
		<cfset strAllValidChars = (
		strLowerCaseAlpha &
		strUpperCaseAlpha &
		strNumbers
		) />
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getStrAllValidChars" access="private" output="false" returntype="string">
		<cfreturn this.strAllValidChars />
	</cffunction>

	<cffunction name="setStrAllValidChars" access="private" output="false" returntype="void">
		<cfargument name="strAllValidChars" type="string" required="true" />
		<cfset this.strAllValidChars = arguments.strAllValidChars />
		<cfreturn />
	</cffunction>

	<cffunction name="generatePass" access="public" output="false" returntype="String">
		<!---
		When creating a password, there are certain rules that we
		need to follow (as deemed by the business logic). That is,
		the password must:
		 
		- must be exactly 10 characters in length
		- must have at least 1 number
		- must have at least 1 uppercase letter
		- must have at least 1 lower case letter
		--->
		<cfset arrPassword = ArrayNew( 1 ) /> 
		<!--- Select the random number from our number set. --->
		<cfset arrPassword[ 1 ] = Mid(
		strNumbers,
		RandRange( 1, Len( strNumbers ) ),
		1
		) />
		 
		
		<!--- Select the random letter from our lower case set. --->
		<cfset arrPassword[ 2 ] = Mid(
		strLowerCaseAlpha,
		RandRange( 1, Len( strLowerCaseAlpha ) ),
		1
		) />
		 
		
		<!--- Select the random letter from our upper case set. --->
		<cfset arrPassword[ 3 ] = Mid(
		strUpperCaseAlpha,
		RandRange( 1, Len( strUpperCaseAlpha ) ),
		1
		) />
		
		<!--- Create rest of the password. --->
		<cfloop
		index="intChar"
		from="#(ArrayLen( arrPassword ) + 1)#"
		to="10"
		step="1">	 
		
			<!---
			Pick random value. For this character, we can choose
			from the entire set of valid characters.
			--->
			<cfset arrPassword[ intChar ] = Mid(
			strAllValidChars,
			RandRange( 1, Len( strAllValidChars ) ),
			1
			) />
		 		
		</cfloop>

		<cfset CreateObject( "java", "java.util.Collections" ).Shuffle(
		arrPassword
		) />
		 
		
		 
		
		<!---
		We now have a randomly shuffled array. Now, we just need
		to join all the characters into a single string. We can
		do this by converting the array to a list and then just
		providing no delimiters (empty string delimiter).
		--->
		<cfset strPassword = ArrayToList(
		arrPassword,
		""
		) /> 		
		<cfreturn strPassword/>
	</cffunction>
</cfcomponent>