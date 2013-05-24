<cfparam name="rc.message" default="#arrayNew(1)#">
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>BCC-Porject: Decision Tree</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="This is a BCC project, developed under bootstrap">
		<meta name="author" content="Xin Zhang">
		<!-- Le styles -->
		<link href="assets/css/bootstrap.css" rel="stylesheet">
		<link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
		<link href="assets/css/custom.css" rel="stylesheet">
		<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
		<!--[if lt IE 9]>
			<script src="assets/js/html5shiv.js"></script>
			<![endif]-->
		<script src="assets/js/jquery-1.9.1.min.js"></script>
	</head>
	<body>
		<div class="navbar navbar-fixed-top">
			<div class="navbar-inner">
				<div class="container-fluid">
					<button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="brand" href="http://www.emory.edu">
						<img src="assets/img/university-logo-high-res-blue-title.png" alt="Emory University" />
					</a>
					<div class="nav-collapse collapse">
						<p class="navbar-text pull-right">
							Welcome, 
							<a href="#" class="navbar-link"><cfoutput>#session.auth.fullname#</cfoutput></a>
						</p>
						<ul class="nav">
							<li class="active">
								<a href="/bmi/decisiontree/index.cfm">Home 
									<i class="icon-home">
									</i></a>
							</li>
							<li><a href="#about">
									About 
								</a></li>
							<li>
								<a href="#contact">Site Management Contact</a>
							</li>
						</ul>
					</div>
					<!--/.nav-collapse -->
				</div>
			</div>
		</div>
		<div id="container-fluid">
			<div class="row-fluid">
				<div class="span3">
					<div class="well sidebar-nav">
						<ul class="nav nav-tabs nav-list nav-stacked">
							<li class="nav-header">Menu</li>
							<li><a href="/bmi/decisiontree/index.cfm">Home</a></li>
							<cfif session.auth.isLoggedIn>
								<li class="dropdown">
									<a class="dropdown-toggle" data-toggle="dropdown" href="#">
										User Mangement
										<b class="caret"></b>
									</a>
									<ul class="dropdown-menu">
									<!-- users -->
										<cfif session.auth.user.getRoleId() is 1>
											<li>
												<a href="index.cfm?action=user.list" title="View the list of users">List Users</a>
											</li>
											<li>
												<a href="index.cfm?action=user.form" title="Fill out form to add new user">Add User</a>
											</li>
										</cfif>
										<li>
											<a href="index.cfm?action=main.password" title="Resets framework cache">Change Password</a>
										</li>								
									</ul>
								</li>
								<li>
									<a href="index.cfm?action=code.list" title="List Decision Codes">List Codes</a>
								</li>								
								<li>
									<a href="index.cfm?action=login.logout" title="Log out the system">Logout</a>
								</li>	
							</cfif>
						</ul>
					</div>
					
				</div>
				<div class="span9">
					<div class="row">
						<div class="span12">
							<div class="hero-unit well leaderboard">
								<h1>Proof of Concept System</h1>
								<p>A dynamic information look-up and decision making system developed by Biostatistics Consulting Center - Rollins School of Public Health.</p>
							</div>
						</div>
					</div>
					
					<div id="primary" class="row">
						<div id="content" class="span12">
							<!--- display any messages to the user --->
							<cfif not arrayIsEmpty(rc.message)>
								<cfloop array="#rc.message#" index="msg">
									<cfoutput>#msg#</cfoutput>
								</cfloop>
							</cfif>					
							<cfoutput>#body#</cfoutput>				
						</div>
					</div> 					
				</div>
			</div>
			<!--end of row-->
		</div>
		

		<!-- Placed at the end of the document so the pages load faster -->
		<script src="assets/js/bootstrap.min.js"></script> 
	</body>
</html>