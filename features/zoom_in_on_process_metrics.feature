Feature: Zoom in on a process's metrics
  	As a support analyst
  	So I can identify detailed timings, detailed magnitudes of metrics and to generally investigate a process's behaviour
  	I want to be able to select a portion of a process metric display (cpu,mem,disk or thread count) in the time axis, 
  	and then display the cpu, mem, disk and thread count metrics for that process for the selected period in a new tab
  	

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
  	
  	# Populate the database with server metric and process metric data
  	And 1 hours of server metrics exist for server "mytestserver" for date "2013-04-04" starting from 12:00 hours
  	And 1 hours of process metrics exist for server "mytestserver" for date "2013-04-04" for process "1234" starting from 12:00 hours
  
	# Login to the Server Diagnostic Centre Homepage, navigate to the System Analyser and view the process metrics for process 1234
	And I log into the Server Diagnostic Centre as user "admin@admin.com" with password "abc1234"
	And I select the tool "System Analyser"
	And I view server metrics for "mytestserver" on "2013-04-04"
    And I select a time range on the "cpu" server metric display for "mytestserver" on "2013-04-04" starting at "12:15" and ending at "12:45"
    And I follow "1234"
	
	
Scenario: Select a portion of any process metric display and zoom in to an expanded view
	When I select a range on any individual process metric display for "mytestserver" on "2013-04-04" starting at "12:25" and ending at "12:35" for process "1234"
	Then I should not see "Previous Day"
	And I should not see "Next Day"
	And I should see "cpu_metrics=[[1365078900000,46.0],[1365078840000,45.0],[1365078780000,44.0],[1365078720000,43.0],[1365078660000,42.0],[1365078600000,41.0],[1365078540000,40.0],[1365078480000,39.0],[1365078420000,38.0],[1365078360000,37.0],[1365078300000,36.0],];"
	And I should see "mem_metrics=[[1365078900000,0.048828125],[1365078840000,0.048828125],[1365078780000,0.048828125],[1365078720000,0.048828125],[1365078660000,0.048828125],[1365078600000,0.048828125],[1365078540000,0.048828125],[1365078480000,0.048828125],[1365078420000,0.048828125],[1365078360000,0.048828125],[1365078300000,0.048828125],];"
	And I should see "disk_metrics=[[1365078900000,500.0],[1365078840000,500.0],[1365078780000,500.0],[1365078720000,500.0],[1365078660000,500.0],[1365078600000,500.0],[1365078540000,500.0],[1365078480000,500.0],[1365078420000,500.0],[1365078360000,500.0],[1365078300000,500.0],];"
	And I should see "thread_metrics=[[1365078900000,1],[1365078840000,1],[1365078780000,1],[1365078720000,1],[1365078660000,1],[1365078600000,1],[1365078540000,1],[1365078480000,1],[1365078420000,1],[1365078360000,1],[1365078300000,1],];"
