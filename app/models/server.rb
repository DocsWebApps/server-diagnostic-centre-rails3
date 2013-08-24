# == Schema Information
#
# Table name: servers
#
#  id         :integer          not null, primary key
#  host_name  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Server < ActiveRecord::Base
  has_many :server_metrics
  has_many :process_metrics
  attr_accessible :host_name
  before_save { |server| server.host_name = host_name.downcase }
  validates :host_name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
end
    

