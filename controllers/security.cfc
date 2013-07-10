<cfcomponent><cfscript>

	function init( fw ) {
		variables.fw = fw;
	}

	function session( rc ) {
		// set up the user's session
		session.auth = {};
		session.auth.isLoggedIn = false;
		session.auth.fullname = 'Guest';
	}
	
	function authorize( rc ) {
		// check to make sure the user is logged on
			if (not isDefined("session.auth.isLoggedIn") ){
				rc.message = ['<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Your session has expired, Please re-login.</div>'];					 					
				session.auth = {};
				session.auth.isLoggedIn = false;
				session.auth.fullname = 'Guest';
				variables.fw.redirect('login','message');
			}else if ( ( not session.auth.isLoggedIn) and 
				not listfindnocase( 'login', variables.fw.getSection() ) and 
				not listfindnocase( 'main.error', variables.fw.getFullyQualifiedAction() ) ) {
				rc.message = ['<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>This is a limited resource, please login to see.</div>'];					 					
				variables.fw.redirect('login','message');
		}
	}

</cfscript></cfcomponent>