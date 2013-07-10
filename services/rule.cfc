<cfcomponent displayname="RuleService" output="false">
	<cfset variables.rules = structNew()>
	<!---The new() method--->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="codeService" type="any" required="true" />
		
		<cfscript>
			setCodeService(arguments.codeService);
			list();
		</cfscript>		
		<cfreturn this>
	</cffunction>

	<cffunction name="setCodeService" access="public" output="false">
		<cfargument name="codeService" type="any" required="true" />
		<cfset variables.codeService = arguments.codeService />
	</cffunction>
	<cffunction name="getCodeService" access="public" returntype="any" output="false">
		<cfreturn variables.codeService />
	</cffunction>
		
	<cffunction name="get" access="public" output="false" returntype="any">
		<cfargument name="id" type="string" required="false" default="">
		<cfset var result = "">
		<cfif len(id) AND structKeyExists(variables.rules, id)>
			<cfset result = variables.rules[id]>
		<cfelse>
			<cfset result = new()>
		</cfif>
		
		<cfreturn result>
	</cffunction>	

	<cffunction name="getByName" access="public" returntype="any">
		<cfargument name="name" type="string" required="false" default="">
		<cfset var result = "">
		<cfif len(name)>
			<cfquery name="getRulebyName" datasource="#Application.DSN#">
				select * from tbl_rules where name='#arguments.name#'
			</cfquery>
		</cfif>
		
		<cfif (not #IsDefined("getRulebyName")#) or #getRulebyName.recordCount# eq 0 >
			<!--- if there is no user with a matching email address, return a blank user --->
			<cfset result = new()>
		<cfelse>
			<cfscript>
				var result=new();
				result.setId(getRulebyName.ID[1]);
				result.setName(getRulebyName.name[1]);
				result.setChar_rule(getRulebyName.char_rule[1]);
				result.setParent_ID(getRulebyName.parent_ID[1]);
				if(getRulebyName.parent_ID[1] neq "0")
					result.setParent(get(getRulebyName.parent_ID[1]));
			</cfscript>	
		</cfif>
		
		<cfreturn result>
	</cffunction>


	<cffunction name="save" access="public" output="false" returntype="void">		
		<cfargument name="rule" type="any" required="true">
		<cflock type="exclusive" name="saverule" timeout="50" throwontimeout="false">
			<!--- since we have an id we are updating a user --->
			<cfif arguments.rule.getId()>
				<cfquery name="updateruleinfo" datasource="#application.dsn#">
					update  tbl_rules
					set name='#arguments.rule.getName()#',
						char_rule='#arguments.rule.getChar_rule()#',
						parent_ID= '#arguments.rule.getParent_ID()#'
					where id=#arguments.rule.getId()#
				</cfquery>
			<cfelse>
			<!--- otherwise a new user is being saved --->
				<cfquery name="saveruleinfo" datasource="#application.dsn#">
					insert into  tbl_rules  (name, char_rule, parent_ID)
					VALUES ('#arguments.rule.getName()#', '#arguments.rule.getChar_rule()#', '#arguments.rule.getParent_ID()#');
				</cfquery>			
			</cfif>
		</cflock>
	</cffunction>		
		
	<cffunction name="list" access="public" output="false" returntype="struct">
		<cfset local.rules = structNew()>
		<cfquery name="qGetRules" datasource="#application.dsn#">
			SELECT     *
			FROM         tbl_rules
			ORDER BY ID
		</cfquery>	
		<cfscript>
		for (x = 1; x <= qGetRules.RecordCount; x=x+1) {
			var rule = new();
			rule.setId(qGetRules.ID[x]);
			rule.setDesc(qGetRules.Description[x]);
			rule.setComp_ID(qGetRules.composed_id[x]);
			rule.setComp_char(qGetRules.composed_charid[x]);
			rule.setCagb(qGetRules.CAGB[x]);
			rule.setPci(qGetRules.PCI[x]);
			local.rules[x] = rule;			
			variables.rules[rule.getId()] = rule;
		}	
		</cfscript>	
				
		<cfreturn local.rules>
    </cffunction>

	<cffunction name="validate" access="public" output="true" returntype="Array">
		<cfargument name="rule" type="any" required="true" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="char_rule" type="string" required="false" default="" />
		<cfargument name="parent_ID" type="string" required="false" default="" />

		<cfset var aErrors = arrayNew(1) />
		

		<!--- Name is required --->
		<cfif not len(arguments.name)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter the name of rule!</div>') />
		</cfif>

		<!--- char rule is required --->
		<cfif not len(arguments.char_rule)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter the char rule of rule!</div>') />
		</cfif>
	

		<!--- Parent id is required--->
		<cfif not len(arguments.parent_ID) or not isnumeric(arguments.parent_ID)>
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please select a parent!</div>') />
		</cfif>
			
		<!--- check to see if a rule exists with the same name --->
		<cfset var ruleByName = getByName(arguments.name) />
		<cfif  not len(arguments.rule.getName()) and len(arguments.name) and ruleByName.getId()>			
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Insert failed! A rule already exists with this name, please enter a new rule.</div>') />
		<cfelseif  len(arguments.rule.getName()) and compare(arguments.name, arguments.rule.getName()) and ruleByName.getId()>			
			<cfset arrayAppend(aErrors,'<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Update failed! A rule already exists with this name, please enter a new rule.</div>') />
		</cfif>

		<cfreturn aErrors />
	</cffunction>	
		
	<cffunction name="new" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "decisionTree.model.Rule").init()>
	</cffunction>	
</cfcomponent>