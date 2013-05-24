<cfoutput>
	<form name="login" id="login" action="#buildURL('login.login')#" method="post" class="form-horizontal">
		<input type="text" id="email" name="email" placeholder="Email" required>
		<input type="password" id="password" name="password" placeholder="Password" required>
		<input type="submit" value="Login" class="btn btn-primary">
	</form>
</cfoutput>

