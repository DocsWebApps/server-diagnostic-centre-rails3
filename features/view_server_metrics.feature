Feature: View server metrics
  	As a support analyst
  	So I can analyse system/server level metrics
  	I want to select a server and a date and then see a display of cpu, memory, net_in, net_out and disk utilisation metrics


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
  	
  	# Populate the database with 1 hour of server metrics
  	And 1 hours of server metrics exist for server "mytestserver" for date "2013-01-01" starting from 13:00 hours
  
	# Login to the Server Diagnostic Centre Homepage
	And I log into the Server Diagnostic Centre as user "admin@admin.com" with password "abc1234"
	And I select the tool "System Analyser"
	
	
Scenario: Select a server and a date to view the cpu, mem, net_in, net_out and disk metrics for that server/date combo
	When I view server metrics for "mytestserver" on "2013-01-01"
	Then I should see "Server Metrics for MYTESTSERVER Taken on 2013-01-01"
	#And I should see "cpu_metrics=[[1357048500000,22.0],[1357048200000,21.0],[1357047900000,20.0],[1357047600000,19.0],[1357047300000,18.0],[1357047000000,17.0],[1357046700000,16.0],[1357046400000,15.0],[1357046100000,14.0],[1357045800000,13.0],[1357045500000,12.0],[1357045200000,11.0],];"
	And I should see "cpu_metrics=[[1357045200000,11.0],[1357045500000,12.0],[1357045800000,13.0],[1357046100000,14.0],[1357046400000,15.0],[1357046700000,16.0],[1357047000000,17.0],[1357047300000,18.0],[1357047600000,19.0],[1357047900000,20.0],[1357048200000,21.0],[1357048500000,22.0],];"
	And I should see "mem_metrics=[[1357045200000,50.0],[1357045500000,50.0],[1357045800000,50.0],[1357046100000,50.0],[1357046400000,50.0],[1357046700000,50.0],[1357047000000,50.0],[1357047300000,50.0],[1357047600000,50.0],[1357047900000,50.0],[1357048200000,50.0],[1357048500000,50.0],];"
	And I should see "netout_metrics=[[1357045200000,500.0],[1357045500000,500.0],[1357045800000,500.0],[1357046100000,500.0],[1357046400000,500.0],[1357046700000,500.0],[1357047000000,500.0],[1357047300000,500.0],[1357047600000,500.0],[1357047900000,500.0],[1357048200000,500.0],[1357048500000,500.0],];"
	And I should see "netin_metrics=[[1357045200000,1000.0],[1357045500000,1000.0],[1357045800000,1000.0],[1357046100000,1000.0],[1357046400000,1000.0],[1357046700000,1000.0],[1357047000000,1000.0],[1357047300000,1000.0],[1357047600000,1000.0],[1357047900000,1000.0],[1357048200000,1000.0],[1357048500000,1000.0],];"
	And I should see "disk_metrics=[[1357045200000,500.0],[1357045500000,500.0],[1357045800000,500.0],[1357046100000,500.0],[1357046400000,500.0],[1357046700000,500.0],[1357047000000,500.0],[1357047300000,500.0],[1357047600000,500.0],[1357047900000,500.0],[1357048200000,500.0],[1357048500000,500.0],];"