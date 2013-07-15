<cfcomponent displayname="CodeService" output="false">
	<cfset variables.codes = structNew()>
	<cfset variables.chars = "ABCDEFGHIGKLMNOPQRSTUVWXYZ">
	<!---The new() method--->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfscript>
			list();
							
		</cfscript>	

		<cfreturn this>
	</cffunction>
	
	<cffunction name="search" access="public" output="false" returntype="struct">
		<cfset local.codes = structNew()>
		<cfquery name="qGetSelection" datasource="#application.dsn#">
			select distinct rule_ID from tbl_rule_map 
		</cfquery>	
		
		<cfquery name="qGetCodes" datasource="#application.dsn#">
			select * from tbl_codes where ID in(
			select distinct parent_ID from tbl_codes where id in (
			select distinct code_select from tbl_rule_map))
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
	
	<cffunction name="update" access="remote" output="true" returntype="struct">
		<cfargument name="condition" type="string" required="true" />
		<cfset local.codes = structNew()>

		<cfquery name="qGetSelection" datasource="#application.dsn#">
			SELECT     Description, composed_charid, CABG, PCI, ID as rule_ID, composed_id
			FROM         tbl_rules
			WHERE     (ID IN
			                          (SELECT     rule_ID
			                            FROM          (SELECT     a.ID, a.rule_ID, a.code_select, b.ID AS Expr1, b.name, b.parent_ID, b.char_code
			                                                    FROM          tbl_rule_map AS a LEFT OUTER JOIN
			                                                                           tbl_codes AS b ON a.code_select = b.ID
			                                                    WHERE      (b.parent_ID IN (#arguments.condition#))) AS derivedtbl_1
			                            GROUP BY rule_ID
			                            HAVING      (COUNT(DISTINCT parent_ID) >= #ListLen(arguments.condition)#)))
		</cfquery>

		<cfquery name="qGetCodes" datasource="#application.dsn#">
			select * from tbl_codes where ID in
				(select distinct parent_ID from tbl_codes where id in 
					(select distinct code_select from tbl_rule_map where rule_ID in (#ValueList(qGetSelection.rule_ID)#)
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
	
	<cffunction name="getChildrenbyParent" access="remote" output="true" returntype="query">
		<cfargument name="parent" type="string" required="true" />
		<cfset local.listofparent="">
		<cfquery name="listofparent" datasource="#application.dsn#">
			SELECT     *
			FROM  tbl_codes
			where Parent_ID=#arguments.parent#
			ORDER BY ID
		</cfquery>
		<cfreturn local.listofparent />
	</cffunction>	

	<cffunction name="get" access="public" output="false" returntype="any">
		<cfargument name="id" type="string" required="false" default="">
		<cfset var result = "">
		<cfif len(id) AND structKeyExists(variables.codes, id)>
			<cfset result = variables.codes[id]>
		<cfelse>
			<cfset result = new()>
		</cfif>
		
		<cfreturn result>
	</cffunction>	

	<cffunction name="getByName" access="public" returntype="any">
		<cfargument name="name" type="string" required="false" default="">
		<cfset var result = "">
		<cfif len(name)>
			<cfquery name="getCodebyName" datasource="#Application.DSN#">
				select * from tbl_codes where name='#arguments.name#'
			</cfquery>
		</cfif>
		
		<cfif (not #IsDefined("getCodebyName")#) or #getCodebyName.recordCount# eq 0 >
			<!--- if there is no user with a matching email address, return a blank user --->
			<cfset result = new()>
		<cfelse>
			<cfscript>
				var result=new();
				result.setId(getCodebyName.ID[1]);
				result.setName(getCodebyName.name[1]);
				result.setChar_code(getCodebyName.char_code[1]);
				result.setParent_ID(getCodebyName.parent_ID[1]);
				if(getCodebyName.parent_ID[1] neq "0")
					result.setParent(get(getCodebyName.parent_ID[1]));
			</cfscript>	
		</cfif>
		
		<cfreturn result>
	</cffunction>

	<cffunction name="getByShortCode" access="public" returntype="any">
		<cfargument name="name" type="string" required="false" default="">
		<cfset var result = "">
		
		<cfif len(name)>
			<cfquery name="getCodebyCode" datasource="#Application.DSN#">
				select * from tbl_codes where char_code='#arguments.name#'
			</cfquery>
		</cfif>

		<cfif (not #IsDefined("getCodebyCode")#) or #getCodebyCode.recordCount# eq 0 >
			<!--- if there is no user with a matching email address, return a blank user --->
			<cfset result = new()>
		<cfelse>
			<cfscript>
				var result=new();
				result.setId(getCodebyCode.ID[1]);
				result.setName(getCodebyCode.name[1]);
				result.setChar_code(getCodebyCode.char_code[1]);
				result.setParent_ID(getCodebyCode.parent_ID[1]);
				if(getCodebyCode.parent_ID[1] neq "0")
					result.setParent(get(getCodebyCode.parent_ID[1]));
			</cfscript>	
		</cfif>
		
		<cfreturn result>
	</cffunction>
		
	<cffunction name="save" access="public" output="false" returntype="void">		
		<cfargument name="code" type="any" required="true">
		<cflock type="exclusive" name="savecode" timeout="50" throwontimeout="false">
			<!--- since we have an id we are updating a user --->
			<cfif arguments.code.getId()>
				<cfquery name="updatecodeinfo" datasource="#application.dsn#">
					update  tbl_codes
					set name='#arguments.code.getName()#',
						char_code='#arguments.code.getChar_code()#',
						parent_ID= '#arguments.code.getParent_ID()#'
					where id=#arguments.code.getId()#
				</cfquery>
			<cfelse>
			<!--- otherwise a new user is being saved --->
				<cfquery name="savecodeinfo" datasource="#application.dsn#">
					insert into  tbl_codes  (name, char_code, parent_ID)
					VALUES ('#arguments.code.getName()#', '#arguments.code.getChar_code()#', '#arguments.code.getParent_ID()#');
				</cfquery>			
			</cfif>
		</cflock>
	</cffunction>		
		
	<cffunction name="list" access="public" output="false" returntype="struct">
		<cfset local.codes = structNew()>
		<cfquery name="qGetCodes" datasource="#application.dsn#">
			SELECT     *
			FROM         tbl_codes
			ORDER BY ID
		</cfquery>	
		<cfscript>
		for (x = 1; x <= qGetCodes.RecordCount; x=x+1) {
			var code = new();
			code.setId(qGetCodes.ID[x]);
			code.setName(qGetCodes.name[x]);
			code.setParent_ID(qGetCodes.Parent_ID[x]);
			code.setChar_code(qGetCodes.Char_code[x]);
			if(qGetCodes.parent_ID[x] neq "0")
				code.setParent(get(qGetCodes.parent_ID[x]));
			local.codes[x] = code;
			
			variables.codes[code.getId()] = code;
		}	
		</cfscript>	
				
		<cfreturn local.codes>
    </cffunction>
	
	<cffunction name="listByCategory" access="public" output="false" returntype="struct">
		<cfset local.codes = structNew()>
		<cfquery name="qGetCodes" datasource="#application.dsn#">
			SELECT     *
			FROM         tbl_codes
			where Parent_ID=0
			ORDER BY Parent_ID,ID
		</cfquery>	
		<cfscript>
		for (x = 1; x <= qGetCodes.RecordCount; x=x+1) {
			var code = new();
			code.setId(qGetCodes.ID[x]);
			code.setName(qGetCodes.name[x]);
			code.setParent_ID(qGetCodes.Parent_ID[x]);
			code.setChar_code(qGetCodes.Char_code[x]);
			if(qGetCodes.parent_ID[x] neq "0")
				code.setParent(get(qGetCodes.parent_ID[x]));
			local.codes[x] = code;
			
			variables.codes[code.getId()] = code;
		}	
		</cfscript>	
				
		<cfreturn local.codes>
    </cffunction>	
	
	<cffunction name="getParentList" access="public" output="false" returntype="struct">
		<cfset local.codes = structNew()>
		<cfquery name="qGetCodes" datasource="#application.dsn#">
			SELECT     *
			FROM         tbl_codes
			where parent_ID=0
			ORDER BY ID
		</cfquery>	
		<cfscript>
		for (x = 1; x <= qGetCodes.RecordCount; x=x+1) {
			var code = new();
			code.setId(qGetCodes.ID[x]);
			code.setName(qGetCodes.name[x]);
			code.setParent_ID(qGetCodes.Parent_ID[x]);
			code.setChar_code(qGetCodes.Char_code[x]);			
			local.codes[code.getId()] = code;
		}	
		</cfscript>		
		<cfreturn local.codes>
    </cffunction>

	<cffunction name="getAvailableParentList" access="public" output="false" returntype="string">
		<cfset local.availablecode = "">
		
		<cfquery name="qGetCodes" datasource="#application.dsn#">
			SELECT     distinct Char_code
			FROM         tbl_codes
			where parent_ID=0
		</cfquery>	
		
		<cfloop	index="intChar"	from="1" to="#Len(variables.chars)#"step="1">
			<cfset strChar = Mid( variables.chars, intChar, 1 ) />
		 	<cfif not #ListFind(ValueList(qGetCodes.Char_code),strChar)#>
		 		<cfset local.availablecode=#ListAppend(local.availablecode,strChar)#>
		 	</cfif>

		</cfloop>
		<cfreturn local.availablecode>
    </cffunction>
				
	<cffunction name="validate" access="public" output="true" returntype="Array">
		<cfargument name="code" type="any" required="true" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="char_code" type="string" required="false" default="" />
		<cfargument name="parent_ID" type="string" required="false" default="" />

		<cfset var aErrors = arrayNew(1) />
		

		<!--- Name is required --->
		<cfif not len(arguments.name)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter the name of code!</div>') />
		</cfif>

		<!--- char code is required --->
		<cfif not len(arguments.char_code)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter the char code of code!</div>') />
		</cfif>

		<!--- Parent id is required--->
		<cfif not len(arguments.parent_ID) or not isnumeric(arguments.parent_ID)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please select a parent!</div>') />
		</cfif>
			
		<!--- check to see if a code exists with the same name --->
		<cfset var codeByName = getByName(arguments.name) />
		<cfif  not len(arguments.code.getName()) and len(arguments.name) and codeByName.getId()>			
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Insert failed! A code already exists with this name, please enter a new code.</div>') />
		<cfelseif  len(arguments.code.getName()) and compare(arguments.name, arguments.code.getName()) and codeByName.getId()>			
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Update failed! A code already exists with this name, please enter a new code.</div>') />
		</cfif>
		
		<!--- check to see if a code exists with the same name --->
		<cfset var codeByShortCode = getByShortCode(arguments.char_code) />
		
		<cfif  not len(arguments.code.getChar_code()) and len(arguments.char_code) and codeByShortCode.getId()>			
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Insert failed! A code already exists with this database code, please enter a new  database code.</div>') />
		<cfelseif  len(arguments.code.getChar_code()) and compare(arguments.char_code, arguments.code.getChar_code()) and codeByShortCode.getId()>			
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Update failed! A code already exists with this database code, please enter a new  database code.</div>') />
		</cfif>		

		<cfreturn aErrors />
	</cffunction>	
		
	<cffunction name="new" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "decisionTree.model.Code").init()>
	</cffunction>	
</cfcomponent>