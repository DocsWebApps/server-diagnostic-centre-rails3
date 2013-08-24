Feature: Change Password
  	As a user of the Server Diagnostic Centre
  	So that I can regularly change my password
  	I want to extend the Diagnostic Centre Homepage to accomodate a password change facility
  	

Background: Populate DB tables with test data and navigate to the starting page for this test
	# Populate the users table with one test user
  	Given the following users exist:
  	| name        | email 			| password | role  | description |
  	| Admin User  | admin@admin.com | abc1234  | admin | Admin Role  |
  	| Basic User  | user@user.com   | abc1234  | user  | Basic Role  |
  	 
	# Login to the Server Diagnostic Centre Homepage
	And I log into the Server Diagnostic Centre as user "admin@admin.com" with password "abc1234"
	Then I should see "Change Your Password"

	
Scenario: Check the change password facility works when I enter the correct details
	When I enter the old password "abc1234", a new password "zyx1234", a confirmation "zyx1234" and submit the request
	Then I should see "Password change successful!"
	
	
Scenario: Check the change password facility displays a problem when I enter the wrong details
	When I enter the old password "abc1234", a new password "zyx1234", a confirmation "zyx1235" and submit the request
	Then I should see "A problem occurred, please retry!"