class SystemAnalyserController < ApplicationController
  # This controller handles all the controller actions for the System Analyser tool. Written by Dave Collier @29/11/2012
  # The System Analyser tool enables a user to analyse server and process metrics for a particular server on a particular day.
  #
  # Associated Models:
  # => ServerMetric; ProcessMetric; Server
  #
  # Associated Views:
  # => display_homepage.html.erb; display_server_metrics.html.erb; display_all_processes_metrics.html.erb; display_single_process_metrics.html.erb
  #
  def display_homepage
    # Invoked by selecting the System Analyser option on the Diagnostic Centre homepage.
    # Retrieves a list of servers stored in the database and returns the System Analyser homepage with a drop down control with the said server list.
    @server_date_switch=true
    @server_list=Server.all
  end

  def home_page_server_select
    # Invoked when you select a server from the System Analyser Homepage.
    # Retrieves a list of disitnct dates for the server for which there is server metric data and re-presents the System Analyser homepage with a date drop down control
    @server_id=params[:server_id]
    @server_date_switch=false
    @server_name=Server.find(@server_id).host_name
    @date_list=ServerMetric.return_date_list(@server_id)
    render 'display_homepage'
  end

  def home_page_date_select
    # Invoked when you select a date from the System Analyser Homepage.
    # Retrieves cpu, memory, network packets in, network packets out and disk usage server level metrics from the ServerMetric model.
    # The selected data is then sent back to the client browser where Flot.js uses the data to produce a graphical time based plot.
    @server_id=params[:server_id]
    @date=params[:date]
    @server_name=Server.find(@server_id).host_name
    @server_metrics=ServerMetric.return_server_data(@server_id,@date)
    render 'display_server_metrics'
  end

  def server_metrics_range_select
    # Invoked when a time range is selected on either the cpu, mem or disk display on the server metrics page.
    # Retreives metrics for all processes running on that server during the time range selected from the ProcessMetric model.
    # Depends on which server metric display you select the range on (cpu display returns cpu data, mem display returns mem data or disk display returns disk data).
    # The selected data is then sent back to the client browser where Flot.js uses the data to produce a graphical time based plot.
    @server_id=params[:server_id]
    @chart_type=params[:chart_type]
    @date=params[:date]
    @server_name=Server.find(@server_id).host_name  
    @process_metrics,@table_data,@units=ProcessMetric.return_allprocesses_data(@date,@chart_type,@server_id,Time.at(((params[:start_time].to_i)/10000)),Time.at(((params[:end_time].to_i)/10000))) 
    render 'display_all_processes_metrics'
  end
 
  def allprocesses_metrics_process_select
    # Invoked when either the process id link is selected from the display_all_processes_metrics page, or the
    # <previous day> option or the <next day> option is selected from the display_single_process_metrics page. 
    # Retreives cpu, mem, disk and thread metrics for that process for the chosen day from the ProcessMetric model.
    # The selected data is then sent back to the client browser where Flot.js uses the data to produce a graphical time based plot.
    @date=params[:date]
    @process_id=params[:process_id].to_s
    @server_id=params[:server_id].to_s
    @server_name=Server.find(@server_id).host_name
    @process_metrics,@process_name,@process_owner=ProcessMetric.return_process_data(@server_id,@date,@process_id)
    date_for_calc=Date.parse(@date)
    @prev_date="<a href='/SystemAnalyserProcessMetrics/"+@process_id+"/"+ @server_id+"/"+(date_for_calc-1).to_s+"' target='_blank'>Previous Day</a>"
    @next_date="<a href='/SystemAnalyserProcessMetrics/"+@process_id+"/"+ @server_id+"/"+(date_for_calc+1).to_s+"' target='_blank'>Next Day</a>"
    render 'display_single_process_metrics'
  end
  
  def process_metrics_range_select
    # Invoked when a time range is selected on either the cpu, mem or disk display on the process metrics page.
    # Retreives cpu, mem, disk and thread metrics for that process for the chosen time period from the ProcessMetric model.
    # The selected data is then sent back to the client browser where Flot.js uses the data to produce a graphical time based plot.
    @server_id=params[:server_id]
    @server_name=Server.find(@server_id).host_name
    @process_id=params[:process_id]
    start_time=params[:start_time].to_i
    end_time=params[:end_time].to_i
    @process_metrics,@process_name,@process_owner,@date=ProcessMetric.return_process_zoom_data(@server_id,@process_id,Time.at(((start_time.to_i)/10000)),Time.at(((end_time.to_i)/10000)))
    @prev_date=""
    @next_date=""
    render 'display_single_process_metrics'
  end   
  
  def allprocesses_metrics_range_select
    # Invoked when a magnitude/time range is selected on either the cpu, mem or disk display on the allprocesses metrics page.
    # Retreives cpu, mem, or disk for the chosen magnitude/time period from the ProcessMetric model.
    # The selected data is then sent back to the client browser where Flot.js uses the data to produce a graphical time based plot.
    @server_id=params[:server_id]
    @server_name=Server.find(@server_id).host_name
    start_time=params[:start_time].to_i
    end_time=params[:end_time].to_i
    upper_value=(params[:upper_value]).to_f/10
    lower_value=(params[:lower_value]).to_f/10
    @chart_type=params[:chart_type]
    @date=params[:date]
    @process_metrics,@table_data,@units=ProcessMetric.return_allprocesses_zoom_data(@server_id,@date,@chart_type,Time.at(((start_time.to_i)/10000)),Time.at(((end_time.to_i)/10000)),lower_value,upper_value)
    render 'display_all_processes_metrics'
  end
end