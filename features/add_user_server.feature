Feature: Add a New User or New Server to the SDC
	As an administrator of the Server Diagnostic Centre
	So that I can add new users and new servers
	I want functionality on the SDC homepage to enable me to add a new user or a new server to the system
	
	
Background: Populate DB tables with test data and navigate to the starting page for this test
	# Populate the users table with one test user
  	Given the following users exist:
  	| name        | email 			| password | role  | description |
  	| Admin User  | admin@admin.com | abc1234  | admin | Admin Role  |
  	| Basic User  | user@user.com   | abc1234  | user  | Basic Role  |
  	
  	# Populate the servers table with one test host
  	And the following hosts exist:
  	| host_name   	|
  	| mytestserver 	|
  	 
	# Login to the Server Diagnostic Centre Homepage
	And I log into the Server Diagnostic Centre as user "admin@admin.com" with password "abc1234"
	Then I should see "Change Your Password"
	
	
Scenario: Add a new user to test it works
	When I enter "a new" "Admin User2", "admin2@admin2.com", "abc1234", "abc1234" and "admin" and press the add new user submit button
	Then I should see "New user added successfully!"

Scenario: Add an existing user to check it fails gracefully
	When I enter "an existing" "Admin", "admin@admin.com", "abc1234", "abc1234" and "admin" and press the add new user submit button
	Then I should see "A problem occurred, please retry!"

Scenario: Add a new server to test it works
	When I enter "a new" "hostname" and press the add new server submit button
	Then I should see "New server added successfully!"
	
Scenario: Add an existing server to check it fails gracefully
	When I enter "an existing" "mytestserver" and press the add new server submit button
	Then I should see "A problem occurred, please retry!"