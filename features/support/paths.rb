# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    
    case page_name
      
    when /^the Server Diagnostic Centre Login page$/
      '/'
      
    when /^the System Analyser Homepage$/
      '/SystemAnalyserHome'
      
    when /^Display date options for server (.*)$/
      "/SystemAnalyserHome/#{$1}"
      
    when /^Display server metrics for server (.*) on date (.*)$/
      "/SystemAnalyserServerMetrics/#{$1}/#{$2}"    
      
    when /^Display all processes metrics for stime (.*) etime (.*) date (.*) server (.*) display (.*)$/ 
       "/SystemAnalyserProcessMetrics/#{$5}/#{$4}/#{$3}/#{$1}/#{$2}"    
       
    when /^Zoom in on all processes metrics for max value (.*) min value (.*) stime (.*) etime (.*) date (.*) server (.*) display (.*)$/ 
       "/SystemAnalyserProcessMetrics/#{$6}/#{$5}/#{$7}/#{$3}/#{$4}/#{$2}/#{$1}" 
         
    when /^Zoom in on individual process metrics for stime (.*) etime (.*) server (.*) process (.*)$/
        "/SystemAnalyserProcessMetrics/#{$4}/#{$3}/#{$1}/#{$2}"
 
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
