<cfparam name="rc.message" default="#arrayNew(1)#">
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Decision Search Tree PI: Omar Lattouf MD/PhD</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="This is a BCC project, developed under bootstrap">
		<meta name="author" content="Xin Zhang">
		<!-- Le styles -->
		<link href="assets/css/bootstrap.css" rel="stylesheet">
		<link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
		<link href="assets/css/custom.css" rel="stylesheet">
		<link rel="stylesheet" type="text/css" href="assets/css/bootstrap-select.min.css">
		<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
		<!--[if lt IE 9]>
			<script src="assets/js/html5shiv.js"></script>
			<![endif]-->
		<script src="assets/js/jquery-2.0.3.min.js"></script>
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
							<cfif #IsDefined("url.action")# and #url.action# eq "main.contact">
								<li>
									<a href="/bmi/decisiontree/index.cfm">Home 
										<i class="icon-home">
										</i></a>
								</li>
								<li class="active">
									<a href="index.cfm?action=main.contact">Site Management Contact</a>
								</li>
							<cfelse>
								<li class="active">
									<a href="/bmi/decisiontree/index.cfm">Home 
										<i class="icon-home">
										</i></a>
								</li>
								<li>
									<a href="index.cfm?action=main.contact">Site Management Contact</a>
								</li>							
							</cfif>
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
								<!--user management-->
								<li class="dropdown">
									<a class="dropdown-toggle" data-toggle="dropdown" href="#">
										User Mangement
										<b class="caret"></b>
									</a>
									<ul class="dropdown-menu">									
										<cfif session.auth.user.getRoleId() is 1>
											<li>
												<a href="index.cfm?action=user.list" title="View the list of users">List Users</a>
											</li>
											<li>
												<a href="index.cfm?action=user.form" title="Fill out form to add new user">Add User</a>
											</li>
										</cfif>
										<li>
											<a href="index.cfm?action=main.password" title="Resets password">Change Password</a>
										</li>								
									</ul>
								</li>
								
								<!--code management-->
								<li class="dropdown">
									<a class="dropdown-toggle" data-toggle="dropdown" href="#">
										DST Mangement
										<b class="caret"></b>
									</a>
									<ul class="dropdown-menu">
									<!-- users -->
										<cfif session.auth.user.getRoleId() is 1>
											<li>
												<a href="index.cfm?action=code.list" title="View the list of indicators">Angiographic and Clinical Indicators (By Sequence)</a>
											</li>										
											<li>
												<a href="index.cfm?action=code.listByCategory" title="View the list of indicators">Angiographic and Clinical Indicators (By Category)</a>
											</li>											
											<li>
												<a href="index.cfm?action=code.form" title="Fill out form to add new indicators">Add New Indicator Codes</a>
											</li>
											<li class="divider"></li>
										</cfif>
										<li>
											<a href="index.cfm?action=code.search" title="List Decision Codes">Decision Search Tree (Vertical View)</a>
										</li>
										<li>
											<a href="index.cfm?action=code.search&horizon=true" title="List Decision Codes">Decision Search Tree (Horizontal View)</a>
										</li>
										<cfif session.auth.user.getRoleId() is 1>
											<li>
												<a href="index.cfm?action=rule.list" title="View the list of rules">List Rules</a>
											</li>										
											<li>
												<a href="index.cfm?action=rule.form" title="Fill out form to add new rules">Add New Rules</a>
											</li>											
										</cfif>																
									</ul>
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
								<h1>Decision Search Tree</h1>
								<p>CABG/PCI intervention based on angiographic and clinical findings.</p>
								<p class="small">PI: Omar Lattouf MD/PhD<br/><em>Version 1.0</em></p>								
							</div>
						</div>
					</div>			
				</div>
			</div>
			<!--end of row-->
			<!--Start contents-->
			<div id="primary" class="row-fluid">
				<div id="content" class="span12">
					<!--- display any messages to the user --->
					<!cfdump var="#rc#"> 
					<cfoutput>#body#</cfoutput>
					<cfif not arrayIsEmpty(rc.message)>
						<cfloop array="#rc.message#" index="msg"><cfoutput>
							#msg#
						</cfoutput></cfloop>
					</cfif>					
				</div>
			</div>
			<!--End contents-->		
		</div>
		

		<!-- Placed at the end of the document so the pages load faster -->
		<script src="assets/js/bootstrap.min.js"></script> 
		<script type="text/javascript" src="assets/js/bootstrap-select.min.js"></script>
		<script type="text/javascript" src="assets/js/bootstrap-multiselect.js"></script>
	</body>
</html>