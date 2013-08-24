Feature: View processes metrics
  	As a support analyst
  	So I can analyse process level metrics
  	I want to select a range on either the cpu, mem or disk server metrics display to then zoom into a second display of cpu, memory or disk metrics at the process level for the time period selected. 
  	I also want a table displayed listing the following process information: process id, process name, process owner, and thread count.
  	I also want a link on process id that opens a new tab to display that process's metrics for that particular day.
  	

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
  	
  	# Populate the database with 1 hours of server/process metrics
  	And 1 hours of server metrics exist for server "mytestserver" for date "2013-04-04" starting from 12:00 hours
  	And 1 hours of process metrics exist for server "mytestserver" for date "2013-04-04" for process "1234" starting from 12:00 hours
  
	# Login to the Diagnostic Centre Homepage, navigate to the System Analyser and view the servermetrics for a server/date combo
	And I log into the Server Diagnostic Centre as user "admin@admin.com" with password "abc1234"
	And I select the tool "System Analyser"
	And I view server metrics for "mytestserver" on "2013-04-04"
	
	
Scenario: Select a range on the cpu server metric display to then display a cpu process level display
	When I select a time range on the "cpu" server metric display for "mytestserver" on "2013-04-04" starting at "12:15" and ending at "12:45"
	Then I should see "CPU Usage"
	And I should see "Individual Processes Running on MYTESTSERVER Taken on 2013-04-04"
	And I should see "p_1234=[[1365079500000,56.0],[1365079440000,55.0],[1365079380000,54.0],[1365079320000,53.0],[1365079260000,52.0],[1365079200000,51.0],[1365079140000,50.0],[1365079080000,49.0],[1365079020000,48.0],[1365078960000,47.0],[1365078900000,46.0],[1365078840000,45.0],[1365078780000,44.0],[1365078720000,43.0],[1365078660000,42.0],[1365078600000,41.0],[1365078540000,40.0],[1365078480000,39.0],[1365078420000,38.0],[1365078360000,37.0],[1365078300000,36.0],[1365078240000,35.0],[1365078180000,34.0],[1365078120000,33.0],[1365078060000,32.0],[1365078000000,31.0],[1365077940000,30.0],[1365077880000,29.0],[1365077820000,28.0],[1365077760000,27.0],[1365077700000,26.0],];"


Scenario: Select a range on the mem server metric display to then display a mem process level display
	When I select a time range on the "mem" server metric display for "mytestserver" on "2013-04-04" starting at "12:15" and ending at "12:45"
	Then I should see "MEM Usage"
	And I should see "Individual Processes Running on MYTESTSERVER Taken on 2013-04-04"
	And I should see " p_1234=[[1365079500000,0.0488281250],[1365079440000,0.0488281250],[1365079380000,0.0488281250],[1365079320000,0.0488281250],[1365079260000,0.0488281250],[1365079200000,0.0488281250],[1365079140000,0.0488281250],[1365079080000,0.0488281250],[1365079020000,0.0488281250],[1365078960000,0.0488281250],[1365078900000,0.0488281250],[1365078840000,0.0488281250],[1365078780000,0.0488281250],[1365078720000,0.0488281250],[1365078660000,0.0488281250],[1365078600000,0.0488281250],[1365078540000,0.0488281250],[1365078480000,0.0488281250],[1365078420000,0.0488281250],[1365078360000,0.0488281250],[1365078300000,0.0488281250],[1365078240000,0.0488281250],[1365078180000,0.0488281250],[1365078120000,0.0488281250],[1365078060000,0.0488281250],[1365078000000,0.0488281250],[1365077940000,0.0488281250],[1365077880000,0.0488281250],[1365077820000,0.0488281250],[1365077760000,0.0488281250],[1365077700000,0.0488281250],];"


Scenario: Select a range on the disk server metric display to then display a disk process level display
	When I select a time range on the "disk" server metric display for "mytestserver" on "2013-04-04" starting at "12:15" and ending at "12:45"
	Then I should see "DISK Usage"
	And I should see "Individual Processes Running on MYTESTSERVER Taken on 2013-04-04"
	And I should see "p_1234=[[1365079500000,500.0],[1365079440000,500.0],[1365079380000,500.0],[1365079320000,500.0],[1365079260000,500.0],[1365079200000,500.0],[1365079140000,500.0],[1365079080000,500.0],[1365079020000,500.0],[1365078960000,500.0],[1365078900000,500.0],[1365078840000,500.0],[1365078780000,500.0],[1365078720000,500.0],[1365078660000,500.0],[1365078600000,500.0],[1365078540000,500.0],[1365078480000,500.0],[1365078420000,500.0],[1365078360000,500.0],[1365078300000,500.0],[1365078240000,500.0],[1365078180000,500.0],[1365078120000,500.0],[1365078060000,500.0],[1365078000000,500.0],[1365077940000,500.0],[1365077880000,500.0],[1365077820000,500.0],[1365077760000,500.0],[1365077700000,500.0],];"
