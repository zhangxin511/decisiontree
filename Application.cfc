<cfcomponent extends="org.corfield.framework">
	<cfscript>
	variables.framework = {
	  reload = 'reload',
	  reloadApplicationOnEveryRequest = true
	};		
	this.mappings["/decisionTree"] = getDirectoryFromPath(getCurrentTemplatePath());
	this.name = 'DecisionTree';
	this.sessionmanagement = true;
	this.sessiontimeout = createTimeSpan(0,0,30,0);
	
	function setupApplication()
	{
		application.adminEmail = 'xzhan64@emory.edu';
		application.dsn = 'omar';
		setBeanFactory(createObject("component", "model.ObjectFactory").init(expandPath("./assets/config/beans.xml.cfm")));
	}

	function setupSession() {
		controller( 'security.session' );
	}

	function setupRequest() {
		controller( 'security.authorize' );
	}
	
	function onMissingView( required struct RC) {
	    // if a data key exists, assume this is for AJAX and render as JSON
	    if ( structKeyExists( RC, "data" ) ) {
	        request.layout = false; // turn off default layout
	        getPageContext().getResponse().getResponse().setContentType('application/json');
	        return serializeJSON( RC.data ); // convert data to JSON
	    } else {
	        return view( 'main/pageNotFound' ); // set view to the missing page message
	    }
	}	
	</cfscript>

</cfcomponent>