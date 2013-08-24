Feature: User login process
  	As a user of the Server Diagnostic Centre
  	So that I can use the application securely
  	I want to login using a username (an email address) and a password
 

Background: Populate DB tables with test data
	# Populate the users table with one test user
  	Given the following users exist:
  	| name        | email 			| password | role  | description |
  	| Admin User  | admin@admin.com | abc1234  | admin | Admin Role  |
  	| Basic User  | user@user.com   | abc1234  | user  | Basic Role  |
  	
  	
Scenario: Successful admin login 
	When I log into the Server Diagnostic Centre as user "admin@admin.com" with password "abc1234"				
  	Then I should see "Welcome to the Server Diagnostic Centre Homepage" 
  	And  I should see "About the Implementation"	
  	And  I should not see "Invalid email / password combination"
  		

Scenario: Failed admin login (wrong password)
  	When I log into the Server Diagnostic Centre as user "admin@admin.com" with password "xxxxx"
  	Then I should see "Invalid email / password combination"
  	And  I should see "Important: Please read !"
  	And  I should not see "Welcome to the Server Diagnostic Centre Homepage" 
  	And  I should not see "About the Implementation"
  	
  
Scenario: Failed any user login (wrong username (email))
  	When I log into the Server Diagnostic Centre as user "xxxxx" with password "abc1234"
  	Then I should see "Invalid email / password combination"
  	And  I should see "Important: Please read !"
  	And  I should not see "Welcome to the Server Diagnostic Centre Homepage" 
  	And  I should not see "About the Implementation"
  	
Scenario: Successful user login 
	When I log into the Server Diagnostic Centre as user "user@user.com" with password "abc1234"				
  	Then I should see "Welcome to the Server Diagnostic Centre Homepage" 
  	And  I should see "About the Implementation"	
  	And  I should not see "Invalid email / password combination"
  		

Scenario: Failed user login (wrong password)
  	When I log into the Server Diagnostic Centre as user "user@user.com" with password "xxxxx"
  	Then I should see "Invalid email / password combination"
  	And  I should see "Important: Please read !"
  	And  I should not see "Welcome to the Server Diagnostic Centre Homepage" 
  	And  I should not see "About the Implementation"
  	