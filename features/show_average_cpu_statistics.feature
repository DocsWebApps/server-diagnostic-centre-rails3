Feature: Calculate average hourly CPU statistics
  	As a support analyst
  	So that I can perform performance benchmarking comprarisons
  	I want to see the average hourly statistics for cpu utilisation on all server metric and individual process displays
  	

Background: Populate DB tables with test data and navigate to the starting page for this test
	# Populate the users table with one test user
  	Given the following users exist:
  	| name        | email 			| password | role  | description |
  	| Admin User  | admin@admin.com | abc1234  | admin | Admin Role  |
  	| Basic User  | user@user.com   | abc1234  | user  | Basic Role  |
  
	# Populate the servers table with one test host
  	And the following hosts exist:
  	| host_name   	|
  	| mytestserver	|
  	
  	# Populate the database with 24 hours of server/process metrics
  	And 24 hours of server metrics exist for server "mytestserver" for date "2013-04-05" starting from 00:00 hours
  	And 24 hours of process metrics exist for server "mytestserver" for date "2013-04-05" for process "1234" starting from 00:00 hours
  
	# Login to the Server Diagnostic Centre Homepage, navigate to the System Analyser and view the servermetrics for a server/date combo
	And I log into the Server Diagnostic Centre as user "admin@admin.com" with password "abc1234"
	And I select the tool "System Analyser"
	
	
Scenario: Check that the average cpu metrics are displayed on the cpu server metrics view 
	When I view server metrics for "mytestserver" on "2013-04-05"
	Then I should see "cpu_av_metrics=[[1365121800000,16],[1365125400000,28],[1365129000000,40],[1365132600000,52],[1365136200000,64],[1365139800000,76],[1365143400000,61],[1365147000000,19],[1365150600000,31],[1365154200000,43],[1365157800000,55],[1365161400000,67],[1365165000000,79],[1365168600000,44],[1365172200000,22],[1365175800000,34],[1365179400000,46],[1365183000000,58],[1365186600000,70],[1365190200000,82],[1365193800000,27],[1365197400000,25],[1365201000000,37],[1365204600000,49],];"
	
	
Scenario: Check that the average cpu metrics are displayed on the individual process metrics view
	When I view server metrics for "mytestserver" on "2013-04-05"
	When I select a time range on the "cpu" server metric display for "mytestserver" on "2013-04-05" starting at "12:15" and ending at "12:45"
	And I follow "1234"
	Then I should see "cpu_av_metrics=[[1365204600000,43],[1365201000000,59],[1365197400000,51],[1365193800000,44],[1365190200000,46],[1365186600000,58],[1365183000000,50],[1365179400000,43],[1365175800000,49],[1365172200000,57],[1365168600000,49],[1365165000000,42],[1365161400000,52],[1365157800000,55],[1365154200000,48],[1365150600000,41],[1365147000000,55],[1365143400000,54],[1365139800000,47],[1365136200000,40],[1365132600000,58],[1365129000000,53],[1365125400000,46],[1365121800000,40],];"
