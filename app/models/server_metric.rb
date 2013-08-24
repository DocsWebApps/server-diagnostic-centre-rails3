# == Schema Information
#
# Table name: server_metrics
#
#  id         :integer          not null, primary key
#  date       :date
#  time       :datetime
#  cpu        :decimal(, )
#  mem        :decimal(, )
#  net_in     :decimal(, )
#  net_out    :decimal(, )
#  disk       :decimal(, )
#  server_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ServerMetric < ActiveRecord::Base
  belongs_to :server
  attr_accessible :cpu, :date, :disk, :mem, :net_in, :net_out, :time
  validates_uniqueness_of :server_id, scope: [:date, :time]
  
  def self.return_date_list(server_id)
    return ServerMetric.select("distinct date").where("server_id=?",server_id).order("date desc")
  end
  
  def self.return_server_data(server_id, date)
    # Initialise and set parameters
    return_data=Hash.new
    return_data['cpu_metrics']=return_data['mem_metrics']=return_data['netin_metrics']=return_data['netout_metrics']=return_data['disk_metrics']=return_data['cpu_av_metrics']='['
    server=Server.find_by_id(server_id)
    
    # Fetch data from the DB
    server_metric_data=server.server_metrics.where("date=?",date).order("time asc")
    
    # Process data returned and preapre it for use in the view
    hour_bar=server_metric_data.first.time.hour.to_i
    av_cpu_sum=0
    count=0
    server_metric_data.each do |data_record|
      time_in_millisecs=(data_record.time.to_i*1000).to_s
      if (data_record.time.hour.to_i == hour_bar)
        av_cpu_sum=av_cpu_sum+data_record.cpu.to_i
        count=count+1
      else
        av_cpu_time_in_millisecs=((Time.parse(date.to_s+' '+hour_bar.to_s+':30UTC').to_i)*1000).to_s
        return_data['cpu_av_metrics']=return_data['cpu_av_metrics']+'['+av_cpu_time_in_millisecs+','+(av_cpu_sum/count).to_s+'],'
        hour_bar=data_record.time.hour.to_i
        av_cpu_sum=data_record.cpu.to_i
        count=1
      end
      return_data['cpu_metrics']=return_data['cpu_metrics']+'['+time_in_millisecs+','+data_record.cpu.to_s+'],'
      return_data['mem_metrics']=return_data['mem_metrics']+'['+time_in_millisecs+','+data_record.mem.to_s+'],'
      return_data['netin_metrics']=return_data['netin_metrics']+'['+time_in_millisecs+','+data_record.net_in.to_s+'],'
      return_data['netout_metrics']=return_data['netout_metrics']+'['+time_in_millisecs+','+data_record.net_out.to_s+'],'
      return_data['disk_metrics']=return_data['disk_metrics']+'['+time_in_millisecs+','+data_record.disk.to_s+'],'
    end
    av_cpu_time_in_millisecs=((Time.parse(date.to_s+' '+hour_bar.to_s+':30UTC').to_i)*1000).to_s
    return_data['cpu_av_metrics']=return_data['cpu_av_metrics']+'['+av_cpu_time_in_millisecs+','+(av_cpu_sum/count).to_s+'],'
    
    # Data CleanUp - Add terminator '];'
    return_data.each do |key,value|
      return_data[key]=return_data[key]+'];'
    end
    
    # Return processed data
    return return_data
  end
end