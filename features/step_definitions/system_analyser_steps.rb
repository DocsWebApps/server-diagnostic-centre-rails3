Given /^the following hosts exist:/ do |hosts_table|
  hosts_table.hashes.each do |host|
    Server.create!(:host_name=>host['host_name'])
  end
end

Given /^(\d+) hours of server metrics exist for server "(.*?)" for date "(.*?)" starting from (\d+):00 hours/ do |hrs,server,dt,start_time|
  svr=Server.find_by_host_name(server)
  stime=start_time.to_i
  etime=stime+(hrs.to_i-1)
  cpu=10
  (stime..etime).each do |hour|
    (0..11).each do |min|
      min=min*5
      cpu=cpu+1
      cpu > 90 ? cpu=10 : cpu=cpu
      svr.server_metrics.create(:date=>dt,:time=>"#{dt} #{hour}:#{min} UTC",:cpu=>"#{cpu}",:mem=>50,:disk=>500,:net_in=>1000,:net_out=>500)
    end
  end
end

Given /^(\d+) hours of process metrics exist for server "(.*?)" for date "(.*?)" for process "(.*?)" starting from (\d+):00 hours/ do |hrs,server,dt,proc_id,start_time|
  svr=Server.find_by_host_name(server)
  stime=start_time.to_i
  etime=stime+(hrs.to_i-1)
  cpu=10
  (stime..etime).each do |hour|
    (0..59).each do |min|
      cpu=cpu+1
      cpu > 90 ? cpu=10 : cpu=cpu
      svr.process_metrics.create!(:date=>dt,:time=>"#{dt} #{hour}:#{min} UTC",:proc_id=>"#{proc_id}",:proc_name=>'process',:proc_owner=>'owner',:cpu=>"#{cpu}",:mem=>50,:disk=>500,:threads=>1)
    end
  end
end

When /^I view server metrics for "(.*?)" on "(.*?)"/ do |svr,dt|
  svr_id=Server.find_by_host_name(svr).id
  select(svr,:field=>'selectServer')
  visit path_to("Display date options for server #{svr_id}")
  select(dt,:field=>'selectdate')
  visit path_to("Display server metrics for server #{svr_id} on date #{dt}")
end

When /^I select a time range on the "(.*?)" server metric display for "(.*?)" on "(.*?)" starting at "(.*?)" and ending at "(.*?)"$/ do |display_type,svr,dt,st,et|
  svr_id=Server.find_by_host_name(svr).id
  st=(Time.parse(dt+" "+st+"UTC").to_i*10000).to_s
  et=(Time.parse(dt+" "+et+"UTC").to_i*10000).to_s
  visit path_to "Display all processes metrics for stime #{st} etime #{et} date #{dt} server #{svr_id} display #{display_type}"
end

When /^I select a range on the "(.*?)" all processes metric display for "(.*?)" on "(.*?)" starting at "(.*?)" and ending at "(.*?)" with max "(.*?)" and min "(.*?)"$/ do |display_type, svr, dt, st, et, max, min|
  svr_id=Server.find_by_host_name(svr).id
  st=(Time.parse(dt+" "+st+"UTC").to_i*10000).to_s
  et=(Time.parse(dt+" "+et+"UTC").to_i*10000).to_s
  max=max.to_i*10
  min=min.to_i*10
  visit path_to "Zoom in on all processes metrics for max value #{max} min value #{min} stime #{st} etime #{et} date #{dt} server #{svr_id} display #{display_type}"
end

When /^I select a range on any individual process metric display for "(.*?)" on "(.*?)" starting at "(.*?)" and ending at "(.*?)" for process "(.*?)"$/ do |svr, dt, st, et, proc_id|
  svr_id=Server.find_by_host_name(svr).id
  st=(Time.parse(dt+" "+st+"UTC").to_i*10000).to_s
  et=(Time.parse(dt+" "+et+"UTC").to_i*10000).to_s
  visit path_to "Zoom in on individual process metrics for stime #{st} etime #{et} server #{svr_id} process #{proc_id}"
end