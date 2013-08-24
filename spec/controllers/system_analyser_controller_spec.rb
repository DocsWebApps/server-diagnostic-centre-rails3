require 'spec_helper'

describe SystemAnalyserController do
  before :all do
    @fake_result='Result'
    @process_id=12345
    @date='2012-01-01'
    @chart_type='cpu'
    @lower_value=10
    @upper_value=90
    
    if !@server=Server.find_by_host_name('testserver')
      @server=Server.create! :host_name=>'testserver'
    end
    @server_id=@server.id
    
    (1..5).each do |num|
      FactoryGirl.create :ServerMetric,:server_id=>@server.id,:date=>'2012-01-01',:time=>"2012-01-01 00:0#{num}"
    end
    
    @start_time=ServerMetric.first.time.to_i*10000
    @end_time=ServerMetric.last.time.to_i*10000
  end 
  
  after :all do
    Server.delete_all
    ServerMetric.delete_all
  end

  describe 'Unit Test for controller method :display_homepage' do     
    it 'Should call the model method ServerMetric:all' do
      Server.should_receive(:all)
      get 'display_homepage'
    end   
    describe 'Check the correct view is returned and the view can access the returned model data' do
      before :each do
        Server.stub(:all).and_return(@fake_result)
        get 'display_homepage'
      end      
      it 'Should return the view :display_homepage' do
        response.should render_template('display_homepage')
      end    
      it 'Should make the data returned from the model availale to the view' do
        assigns(:server_list).should == @fake_result
      end   
    end  
  end


  describe 'Unit Test for controller method :home_page_server_select' do    
    it 'Should call the model method ServerMetric:return_date_list' do
      ServerMetric.should_receive(:return_date_list).with(@server_id.to_s)
      get 'home_page_server_select',{:server_id=>@server_id}
    end    
    describe 'Check the correct view is returned and the view can access the returned model data' do
      before :each do
        ServerMetric.stub(:return_date_list).and_return(@fake_result)
        get 'home_page_server_select',{:server_id=>@server_id}
      end      
      it 'Should return the view :display_homepage' do
        response.should render_template('display_homepage')
      end    
      it 'Should make the data returned from the model availale to the view' do
        assigns(:date_list).should == @fake_result
      end     
    end  
  end

  describe 'Unit Test for controller method :home_page_date_select' do            
    it 'Should call the model method ServerMetric:return_server_metric_data' do
      ServerMetric.should_receive(:return_server_data).with(@server_id.to_s,@date).and_return(@fake_result)
      get 'home_page_date_select',{:server_id=>@server_id,:date=>@date}
    end    
    describe 'Check the correct view is returned and the view can access the returned model data' do
      before :each do
        ServerMetric.stub(:return_server_data).and_return(@fake_result)
        get 'home_page_date_select',{:server_id=>@server_id,:date=>@date}
      end      
      it 'Should return the view :display_server_metrics' do
        response.should render_template('display_server_metrics')
      end    
      it 'Should make the data returned from the model availale to the view' do
        assigns(:server_metrics).should==@fake_result
      end   
    end  
  end

  describe 'Unit Test for controller method :server_metrics_range_select' do            
    it 'Should call the model method ProcessMetric:return_processes_metric_data' do
      ProcessMetric.should_receive(:return_allprocesses_data).with(@date,@chart_type,@server_id.to_s,Time.at(((@start_time.to_i)/10000)),Time.at(((@end_time.to_i)/10000)))      
      get 'server_metrics_range_select', {:server_id=>@server_id,:date=>@date,:chart_type=>@chart_type,:start_time=>@start_time,:end_time=>@end_time}
    end    
    describe 'Check the correct view is returned and the view can access the returned model data' do
      before :each do
        ProcessMetric.stub(:return_allprocesses_data).and_return(@fake_result)
        get 'server_metrics_range_select',{:server_id=>@server_id,:date=>@date,:chart_type=>@chart_type,:start_time=>@start_time,:end_time=>@end_time}
      end      
      it 'Should return the view :display_all_processes_metrics' do
        response.should render_template('display_all_processes_metrics')
      end    
      it 'Should make the data returned from the model availale to the view' do
        assigns(:process_metrics).should==@fake_result
      end   
    end  
  end 

  describe 'Unit Test for controller method :allprocesses_metrics_process_select' do            
    it 'Should call the model method ProcessMetric:return_process_metric_data' do
      ProcessMetric.should_receive(:return_process_data).with(@server_id.to_s,@date,@process_id.to_s)
      get 'allprocesses_metrics_process_select',{:server_id=>@server_id,:date=>@date,:process_id=>@process_id}
    end    
    describe 'Check the correct view is returned and the view can access the returned model data' do
      before :each do
        ProcessMetric.stub(:return_process_data).and_return(@fake_result)
        get 'allprocesses_metrics_process_select',{:server_id=>@server_id,:date=>@date,:process_id=>@process_id}
      end      
      it 'Should return the view :display_single_process_metrics' do
        response.should render_template('display_single_process_metrics')
      end    
      it 'Should make the data returned from the model availale to the view' do
        assigns(:process_metrics).should==@fake_result
      end   
    end  
  end

  describe 'Unit Test for controller method :process_metrics_range_select' do        
    it 'Should call the model method ProcessMetric:return_process_metric_zoom' do
      ProcessMetric.should_receive(:return_process_zoom_data).with(@server_id.to_s,@process_id.to_s,Time.at(@start_time.to_i/10000),Time.at(@end_time.to_i/10000))
      get "process_metrics_range_select",{:process_id=>@process_id,:server_id=>@server_id,:start_time=>@start_time,:end_time=>@end_time}
    end    
    describe 'Check the correct view is returned and the view can access the returned model data' do
      before :each do
        ProcessMetric.stub(:return_process_zoom_data).and_return(@fake_result)
        get "process_metrics_range_select",{:process_id=>@process_id,:server_id=>@server_id,:start_time=>@start_time,:end_time=>@end_time}
      end      
      it 'Should return the view :display_zoom_process_metrics' do
        response.should render_template('display_single_process_metrics')
      end    
      it 'Should make the data returned from the model availale to the view' do
        assigns(:process_metrics).should==@fake_result
      end   
    end  
 end

  describe 'Unit Test for controller method :allprocesses_metrics_range_select' do        
    it 'Should call the model method ProcessMetric:return_allprocesses_metric_zoom' do
      ProcessMetric.should_receive(:return_allprocesses_zoom_data).with(@server_id.to_s,@date,@chart_type,Time.at(@start_time.to_i/10000),Time.at(@end_time.to_i/10000),@lower_value,@upper_value)
      get 'allprocesses_metrics_range_select',{:server_id=>@server_id,:date=>@date,:chart_type=>@chart_type,:start_time=>@start_time,:end_time=>@end_time,:lower_value=>(@lower_value*10),:upper_value=>(@upper_value*10)}
    end    
    describe 'Check the correct view is returned and the view can access the returned model data' do 
      before :each do
        ProcessMetric.stub(:return_allprocesses_zoom_data).and_return(@fake_result)
        get 'allprocesses_metrics_range_select',{:server_id=>@server_id,:date=>@date,:chart_type=>@chart_type,:start_time=>@start_time,:end_time=>@end_time,:lower_value=>@lower_value,:upper_value=>@upper_value}
      end    
      it 'Should return the view :display_all_processes_metrics' do
        response.should render_template('display_all_processes_metrics')
      end
      it 'Should make the data returned from the model availale to the view' do
        assigns(:process_metrics) == @fake_result
      end  
    end  
  end
end  