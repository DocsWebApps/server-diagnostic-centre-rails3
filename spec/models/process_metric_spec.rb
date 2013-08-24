# == Schema Information
#
# Table name: process_metrics
#
#  id         :integer          not null, primary key
#  date       :date
#  time       :datetime
#  proc_id    :integer
#  proc_name  :string(255)
#  proc_owner :string(255)
#  cpu        :decimal(, )
#  mem        :decimal(, )
#  threads    :integer
#  disk       :decimal(, )
#  server_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe ProcessMetric do
  before :all do
    @start_time=Time.utc(2012,"jan",1,0,20,0)
    @end_time=Time.utc(2012,"jan",1,0,30,0)
    @proc_id=12345
    @proc_name='process1'
    @proc_owner='owner'
    @date=Date.parse('01/01/2012')
    
    if !@server=Server.find_by_host_name('testserver')
      @server=FactoryGirl.create :Server,:host_name=>'testserver'
    end

    (10..50).each do |num|
      FactoryGirl.create :ProcessMetric,:server_id=>@server.id,:date=>'2012-01-01',:time=>"2012-01-01 00:#{num}",:proc_id=>@proc_id,:mem=>(10*num*1024),:cpu=>(40+num),:disk=>(500+num),:threads=>1,:proc_name=>@proc_name,:proc_owner=>@proc_owner
    end
  end
  
  after :all do
    Server.delete_all
    ProcessMetric.delete_all
  end
  
  describe 'Check ProcessMetric Model Validations' do
    it 'Should have a unique combination of server,date,time and proc_id' do
      @server.process_metrics.create :date=>'2012-01-01',:time=>'2012-01-01 00:00',:proc_id=>12345
      metric=@server.process_metrics.new :date=>'2012-01-01',:time=>'2012-01-01 00:00',:proc_id=>12345
      metric.should_not be_valid
    end
  end
  
  describe 'Test method :return_allprocesses_zoom_data' do 
    it 'Should return a subset of mem data from ProcessMetric' do
      process_metric,process_table,units=ProcessMetric.return_allprocesses_zoom_data(@server.id,@date,'mem',@start_time,@end_time,(245760),(286720))
      process_metric[12345].should eq('[[1325377680000,280.0000000000],[1325377620000,270.0000000000],[1325377560000,260.0000000000],[1325377500000,250.0000000000],[1325377440000,240.0000000000],];')
      process_table[12345].should eq("<tr><td><a href='/SystemAnalyserProcessMetrics/12345/#{@server.id}/2012-01-01' target='_blank'>12345</a></td><td>#{@proc_name}</td><td>#{@proc_owner}</td><td>1</td></tr>")
      units.should eq("(MB)")
    end
    
    it 'Should return a subset of cpu data from ProcessMetric' do
      process_metric,process_table,units=ProcessMetric.return_allprocesses_zoom_data(@server.id,@date,'cpu',@start_time,@end_time,64,68)
      process_metric[12345].should eq('[[1325377680000,68.0],[1325377620000,67.0],[1325377560000,66.0],[1325377500000,65.0],[1325377440000,64.0],];')
      process_table[12345].should eq("<tr><td><a href='/SystemAnalyserProcessMetrics/12345/#{@server.id}/2012-01-01' target='_blank'>12345</a></td><td>#{@proc_name}</td><td>#{@proc_owner}</td><td>1</td></tr>")
      units.should eq("(%)")
    end
    
    it 'Should return a subset of disk data from ProcessMetric' do
      process_metric,process_table,units=ProcessMetric.return_allprocesses_zoom_data(@server.id,@date,'disk',@start_time,@end_time,524,528)
      process_metric[12345].should eq('[[1325377680000,528.0],[1325377620000,527.0],[1325377560000,526.0],[1325377500000,525.0],[1325377440000,524.0],];')
      process_table[12345].should eq("<tr><td><a href='/SystemAnalyserProcessMetrics/12345/#{@server.id}/2012-01-01' target='_blank'>12345</a></td><td>#{@proc_name}</td><td>#{@proc_owner}</td><td>1</td></tr>")
      units.should eq("(IO/s)")
    end   
  end
  
  describe 'Test method :return_allprocesses_data' do
    it 'Should return a set of cpu process level data for the time period selected' do
      process_metric,process_table,units=ProcessMetric.return_allprocesses_data(@date,'cpu',@server.id,@start_time,@end_time)
      process_metric[12345].should eq('[[1325377800000,70.0],[1325377740000,69.0],[1325377680000,68.0],[1325377620000,67.0],[1325377560000,66.0],[1325377500000,65.0],[1325377440000,64.0],[1325377380000,63.0],[1325377320000,62.0],[1325377260000,61.0],[1325377200000,60.0],];')
      process_table[12345].should eq("<tr><td><a href='/SystemAnalyserProcessMetrics/12345/#{@server.id}/2012-01-01' target='_blank'>12345</a></td><td>#{@proc_name}</td><td>#{@proc_owner}</td><td>1</td></tr>")
      units.should eq("(%)")
    end
    
    it 'Should return a set of mem process level data for the time period selected' do
      process_metric,process_table,units=ProcessMetric.return_allprocesses_data(@date,'mem',@server.id,@start_time,@end_time)
      process_metric[12345].should eq('[[1325377800000,300.0000000000],[1325377740000,290.0000000000],[1325377680000,280.0000000000],[1325377620000,270.0000000000],[1325377560000,260.0000000000],[1325377500000,250.0000000000],[1325377440000,240.0000000000],[1325377380000,230.0000000000],[1325377320000,220.0000000000],[1325377260000,210.0000000000],[1325377200000,200.0000000000],];')
      process_table[12345].should eq("<tr><td><a href='/SystemAnalyserProcessMetrics/12345/#{@server.id}/2012-01-01' target='_blank'>12345</a></td><td>#{@proc_name}</td><td>#{@proc_owner}</td><td>1</td></tr>")
      units.should eq("(MB)")
    end
    
    it 'Should return a set of disk process level data for the time period selected' do
      process_metric,process_table,units=ProcessMetric.return_allprocesses_data(@date,'disk',@server.id,@start_time,@end_time)
      process_metric[12345].should eq('[[1325377800000,530.0],[1325377740000,529.0],[1325377680000,528.0],[1325377620000,527.0],[1325377560000,526.0],[1325377500000,525.0],[1325377440000,524.0],[1325377380000,523.0],[1325377320000,522.0],[1325377260000,521.0],[1325377200000,520.0],];')
      process_table[12345].should eq("<tr><td><a href='/SystemAnalyserProcessMetrics/12345/#{@server.id}/2012-01-01' target='_blank'>12345</a></td><td>#{@proc_name}</td><td>owner</td><td>1</td></tr>")
      units.should eq("(IO/s)")
    end
  end
  
  describe 'Test method :return_process_data' do
    it 'Should return all the process data for the process for that day (cpu,mem,disk,thread)' do
      process_metric,process_name,process_owner=ProcessMetric.return_process_data(@server.id,@date,@proc_id)
      process_metric['cpu_metrics'].should eq('[[1325379000000,90.0],[1325378940000,89.0],[1325378880000,88.0],[1325378820000,87.0],[1325378760000,86.0],[1325378700000,85.0],[1325378640000,84.0],[1325378580000,83.0],[1325378520000,82.0],[1325378460000,81.0],[1325378400000,80.0],[1325378340000,79.0],[1325378280000,78.0],[1325378220000,77.0],[1325378160000,76.0],[1325378100000,75.0],[1325378040000,74.0],[1325377980000,73.0],[1325377920000,72.0],[1325377860000,71.0],[1325377800000,70.0],[1325377740000,69.0],[1325377680000,68.0],[1325377620000,67.0],[1325377560000,66.0],[1325377500000,65.0],[1325377440000,64.0],[1325377380000,63.0],[1325377320000,62.0],[1325377260000,61.0],[1325377200000,60.0],[1325377140000,59.0],[1325377080000,58.0],[1325377020000,57.0],[1325376960000,56.0],[1325376900000,55.0],[1325376840000,54.0],[1325376780000,53.0],[1325376720000,52.0],[1325376660000,51.0],[1325376600000,50.0],];')
      process_metric['mem_metrics'].should eq('[[1325379000000,500.0],[1325378940000,490.0],[1325378880000,480.0],[1325378820000,470.0],[1325378760000,460.0],[1325378700000,450.0],[1325378640000,440.0],[1325378580000,430.0],[1325378520000,420.0],[1325378460000,410.0],[1325378400000,400.0],[1325378340000,390.0],[1325378280000,380.0],[1325378220000,370.0],[1325378160000,360.0],[1325378100000,350.0],[1325378040000,340.0],[1325377980000,330.0],[1325377920000,320.0],[1325377860000,310.0],[1325377800000,300.0],[1325377740000,290.0],[1325377680000,280.0],[1325377620000,270.0],[1325377560000,260.0],[1325377500000,250.0],[1325377440000,240.0],[1325377380000,230.0],[1325377320000,220.0],[1325377260000,210.0],[1325377200000,200.0],[1325377140000,190.0],[1325377080000,180.0],[1325377020000,170.0],[1325376960000,160.0],[1325376900000,150.0],[1325376840000,140.0],[1325376780000,130.0],[1325376720000,120.0],[1325376660000,110.0],[1325376600000,100.0],];')
      process_metric['disk_metrics'].should eq('[[1325379000000,550.0],[1325378940000,549.0],[1325378880000,548.0],[1325378820000,547.0],[1325378760000,546.0],[1325378700000,545.0],[1325378640000,544.0],[1325378580000,543.0],[1325378520000,542.0],[1325378460000,541.0],[1325378400000,540.0],[1325378340000,539.0],[1325378280000,538.0],[1325378220000,537.0],[1325378160000,536.0],[1325378100000,535.0],[1325378040000,534.0],[1325377980000,533.0],[1325377920000,532.0],[1325377860000,531.0],[1325377800000,530.0],[1325377740000,529.0],[1325377680000,528.0],[1325377620000,527.0],[1325377560000,526.0],[1325377500000,525.0],[1325377440000,524.0],[1325377380000,523.0],[1325377320000,522.0],[1325377260000,521.0],[1325377200000,520.0],[1325377140000,519.0],[1325377080000,518.0],[1325377020000,517.0],[1325376960000,516.0],[1325376900000,515.0],[1325376840000,514.0],[1325376780000,513.0],[1325376720000,512.0],[1325376660000,511.0],[1325376600000,510.0],];')
      process_metric['thread_metrics'].should eq('[[1325379000000,1],[1325378940000,1],[1325378880000,1],[1325378820000,1],[1325378760000,1],[1325378700000,1],[1325378640000,1],[1325378580000,1],[1325378520000,1],[1325378460000,1],[1325378400000,1],[1325378340000,1],[1325378280000,1],[1325378220000,1],[1325378160000,1],[1325378100000,1],[1325378040000,1],[1325377980000,1],[1325377920000,1],[1325377860000,1],[1325377800000,1],[1325377740000,1],[1325377680000,1],[1325377620000,1],[1325377560000,1],[1325377500000,1],[1325377440000,1],[1325377380000,1],[1325377320000,1],[1325377260000,1],[1325377200000,1],[1325377140000,1],[1325377080000,1],[1325377020000,1],[1325376960000,1],[1325376900000,1],[1325376840000,1],[1325376780000,1],[1325376720000,1],[1325376660000,1],[1325376600000,1],];')
      process_metric['cpu_av_metrics'].should eq('[[1325377800000,70],];')
      process_name.should eq(@proc_name)
      process_owner.should eq(@proc_owner)
    end
  end
  
  describe 'Test method :return_process_zoom_data' do
    it 'Should return a subset of process data for a given time period' do
      process_metric,process_name,process_owner,process_date=ProcessMetric.return_process_zoom_data(@server.id,@proc_id,@start_time,@end_time)
      process_metric['cpu_metrics'].should eq('[[1325377800000,70.0],[1325377740000,69.0],[1325377680000,68.0],[1325377620000,67.0],[1325377560000,66.0],[1325377500000,65.0],[1325377440000,64.0],[1325377380000,63.0],[1325377320000,62.0],[1325377260000,61.0],[1325377200000,60.0],];')
      process_metric['mem_metrics'].should eq('[[1325377800000,300.0],[1325377740000,290.0],[1325377680000,280.0],[1325377620000,270.0],[1325377560000,260.0],[1325377500000,250.0],[1325377440000,240.0],[1325377380000,230.0],[1325377320000,220.0],[1325377260000,210.0],[1325377200000,200.0],];')
      process_metric['disk_metrics'].should eq('[[1325377800000,530.0],[1325377740000,529.0],[1325377680000,528.0],[1325377620000,527.0],[1325377560000,526.0],[1325377500000,525.0],[1325377440000,524.0],[1325377380000,523.0],[1325377320000,522.0],[1325377260000,521.0],[1325377200000,520.0],];')
      process_metric['thread_metrics'].should eq('[[1325377800000,1],[1325377740000,1],[1325377680000,1],[1325377620000,1],[1325377560000,1],[1325377500000,1],[1325377440000,1],[1325377380000,1],[1325377320000,1],[1325377260000,1],[1325377200000,1],];')
      process_name.should eq(@proc_name)
      process_owner.should eq(@proc_owner)
      process_date.should eq(@date)
    end
  end  
end