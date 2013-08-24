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

class ProcessMetric < ActiveRecord::Base
  belongs_to :server
  attr_accessible :cpu, :date, :disk, :mem, :proc_id, :proc_name, :proc_owner, :threads, :time
  validates_uniqueness_of :server_id, scope: [:date, :time, :proc_id] 
  
  def self.return_allprocesses_zoom_data(server_id,date,type,start_time,end_time,lower_value,upper_value)
    # Initialise and set parameters
    return_process_data=Hash.new
    return_process_table_data=Hash.new
    server=Server.find_by_id(server_id)
    units=""
    
    # Fetch data from the DB
    if type=='cpu'
      units="(%)"
      process_metric_data=server.process_metrics.select("time,proc_id,proc_name,proc_owner,cpu metric,threads").where("time between ? and ? and cpu between ? and ?",start_time,end_time,lower_value,upper_value).order("time desc")
    elsif type=='mem'
      units="(MB)"
      process_metric_data=server.process_metrics.select("time,proc_id,proc_name,proc_owner,round((mem/1024),10) metric,threads").where("time between ? and ? and mem between ? and ?",start_time,end_time,(lower_value),(upper_value)).order("time desc")
    else
      units="(IO/s)"
      process_metric_data=server.process_metrics.select("time,proc_id,proc_name,proc_owner,disk metric,threads").where("time between ? and ? and disk between ? and ?",start_time,end_time,lower_value,upper_value).order("time desc")
    end
    
    # Process data returned and preapre it for use in the view
    process_metric_data.each do |data_record|
      time_in_millisecs=(data_record.time.to_i*1000).to_s
      metric_value=data_record.metric.to_s
      process_id=data_record.proc_id
      process_id_as_string=process_id.to_s
      if !return_process_data.has_key?(process_id)
        return_process_data[process_id]='[['+time_in_millisecs+','+metric_value+'],'
        return_process_table_data[process_id]="<tr><td><a href='/SystemAnalyserProcessMetrics/"+process_id_as_string+'/'+server_id.to_s+'/'+date.to_s+"' target='_blank'>"+process_id_as_string+'</a></td><td>'+data_record.proc_name+'</td><td>'+data_record.proc_owner+'</td><td>'+data_record.threads.to_i.to_s+'</td></tr>'
      else
        return_process_data[process_id]=return_process_data[process_id]+'['+time_in_millisecs+','+metric_value+'],'
      end
    end
    
    # Data CleanUp - Add terminator '];'
    return_process_data.each do |key,value|
      return_process_data[key]=return_process_data[key]+'];'  
    end    
    
    # Return processed data
    return return_process_data,return_process_table_data,units
  end
  
  def self.return_allprocesses_data(date,type,server_id,start_time,end_time)
    # Initialise and set parameters
    return_process_data=Hash.new
    return_process_table_data=Hash.new
    server=Server.find_by_id(server_id)
    units=""
    
    # Fetch data from the DB
    if type=='cpu'
      units="(%)"
      process_metric_data=server.process_metrics.select("time,proc_id,proc_name,proc_owner,cpu metric,threads").where("time between ? and ?",start_time,end_time).order("time desc")
    elsif type=='mem'
      units="(MB)"
      process_metric_data=server.process_metrics.select("time,proc_id,proc_name,proc_owner,round((mem/1024),10) metric,threads").where("time between ? and ?",start_time,end_time).order("time desc")
    else
      units="(IO/s)"
      process_metric_data=server.process_metrics.select("time,proc_id,proc_name,proc_owner,disk metric,threads").where("time between ? and ?",start_time,end_time).order("time desc")
    end
    
    # Process data returned and preapre it for use in the view
    process_metric_data.each do |data_record|
      time_in_millisecs=(data_record.time.to_i*1000).to_s
      metric_value=data_record.metric.to_s
      process_id=data_record.proc_id
      process_id_as_string=process_id.to_s
      if !return_process_data.has_key?(process_id)
        return_process_data[process_id]='[['+time_in_millisecs+','+metric_value+'],'
        return_process_table_data[process_id]="<tr><td><a href='/SystemAnalyserProcessMetrics/"+process_id_as_string+'/'+server_id.to_s+'/'+date.to_s+"' target='_blank'>"+process_id_as_string+'</a></td><td>'+data_record.proc_name+'</td><td>'+data_record.proc_owner+'</td><td>'+data_record.threads.to_i.to_s+'</td></tr>'
      else
        return_process_data[process_id]=return_process_data[process_id]+'['+time_in_millisecs+','+metric_value+'],'
      end
    end
    
    # Data CleanUp - Add terminator '];'
    return_process_data.each do |key,value|
      return_process_data[key]=return_process_data[key]+'];'  
    end
    
    # Return processed data
    return return_process_data,return_process_table_data,units
  end
  
  def self.return_process_data(server_id,date,process_id)
    # Initialise and set parameters
    return_process_data=Hash.new
    return_process_name=return_process_owner=""
    return_process_data['cpu_metrics']=return_process_data['mem_metrics']=return_process_data['disk_metrics']=return_process_data['thread_metrics']=return_process_data['cpu_av_metrics']='['
    server=Server.find_by_id(server_id)
    
    # Fetch data from the DB
    process_metric_data=server.process_metrics.where("proc_id=? and date=?",process_id,date).order("time desc")
    
    # Process data returned and preapre it for use in the view
    hour_bar=process_metric_data.first.time.hour.to_i
    av_cpu_sum=0
    count=0
    process_metric_data.each do |data_record|
      return_process_name=data_record.proc_name
      return_process_owner=data_record.proc_owner
      cpu=data_record.cpu.to_s
      mem=(data_record.mem/1024).to_s
      disk=data_record.disk.to_s
      threads=data_record.threads.to_s
      time_in_millisecs=(data_record.time.to_i*1000).to_s
      if (data_record.time.hour.to_i == hour_bar)
        av_cpu_sum=av_cpu_sum+data_record.cpu.to_i
        count=count+1
      else
        av_cpu_time_in_millisecs=((Time.parse(date.to_s+' '+hour_bar.to_s+':30UTC').to_i)*1000).to_s
        return_process_data['cpu_av_metrics']=return_process_data['cpu_av_metrics']+'['+av_cpu_time_in_millisecs+','+(av_cpu_sum/count).to_s+'],'
        hour_bar=data_record.time.hour.to_i
        av_cpu_sum=data_record.cpu.to_i
        count=1
      end
      return_process_data['cpu_metrics']=return_process_data['cpu_metrics']+'['+time_in_millisecs+','+cpu+'],'
      return_process_data['mem_metrics']=return_process_data['mem_metrics']+'['+time_in_millisecs+','+mem+'],'
      return_process_data['disk_metrics']=return_process_data['disk_metrics']+'['+time_in_millisecs+','+disk+'],'
      return_process_data['thread_metrics']=return_process_data['thread_metrics']+'['+time_in_millisecs+','+threads+'],'
    end
    av_cpu_time_in_millisecs=((Time.parse(date.to_s+' '+hour_bar.to_s+':30UTC').to_i)*1000).to_s
    return_process_data['cpu_av_metrics']=return_process_data['cpu_av_metrics']+'['+av_cpu_time_in_millisecs+','+(av_cpu_sum/count).to_s+'],'
    
    # Data CleanUp - Add terminator '];'
    return_process_data.each do |key,value|
      return_process_data[key]=return_process_data[key]+'];'  
    end
    
    # Return processed data
    return return_process_data,return_process_name,return_process_owner
  end
  
  def self.return_process_zoom_data(server_id,process_id,start_time,end_time)
    # Initialise and set parameters
    return_process_data=Hash.new
    return_process_name=return_process_owner=return_date=""
    return_date=Date.new
    return_process_data['cpu_metrics']=return_process_data['mem_metrics']=return_process_data['disk_metrics']=return_process_data['thread_metrics']='['
    server=Server.find_by_id(server_id)
    
    # Fetch data from the DB
    process_metric_data=server.process_metrics.where("proc_id=? and time between ? and ?",process_id,start_time,end_time).order("time desc")
    
    # Process data returned and preapre it for use in the view
    process_metric_data.each do |data_record|
      return_date=data_record.date
      return_process_name=data_record.proc_name
      return_process_owner=data_record.proc_owner
      cpu=data_record.cpu.to_s
      mem=(data_record.mem/1024).to_s
      disk=data_record.disk.to_s
      threads=data_record.threads.to_s
      time_in_millisecs=(data_record.time.to_i*1000).to_s
      return_process_data['cpu_metrics']=return_process_data['cpu_metrics']+'['+time_in_millisecs+','+cpu+'],'
      return_process_data['mem_metrics']=return_process_data['mem_metrics']+'['+time_in_millisecs+','+mem+'],'
      return_process_data['disk_metrics']=return_process_data['disk_metrics']+'['+time_in_millisecs+','+disk+'],'
      return_process_data['thread_metrics']=return_process_data['thread_metrics']+'['+time_in_millisecs+','+threads+'],'
    end
    
    # Data CleanUp - Add terminator '];'
    return_process_data.each do |key,value|
      return_process_data[key]=return_process_data[key]+'];'  
    end
    
    # Return processed data
    return return_process_data,return_process_name,return_process_owner,return_date
  end
end
