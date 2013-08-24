Feature: Tool selection process
  	As a user of the Server Diagnostic Centre
  	So that I can use a particular analysis tool
  	I want to select an analysis tool from a drop down list and view the homepage of the tool in a new tab of the browser


Background: Populate DB tables with test data and login to the Diagnostice Centre
	# Populate the users table with one test user
  	Given the following users exist:
  	| name        | email 			| password | role  | description |
  	| Admin User  | admin@admin.com | abc1234  | admin | Admin Role  |
  	| Basic User  | user@user.com   | abc1234  | user  | Basic Role  |
  	
	# Login to the Server Diagnostic Centre Homepage
	And I log into the Server Diagnostic Centre as user "admin@admin.com" with password "abc1234"


Scenario: Select the System Analyser Tool
  	When I select the tool "System Analyser"
  	Then I should see "Welcome to the System Analyser Homepage"
  	And I should see "How to Use the System Analyser"