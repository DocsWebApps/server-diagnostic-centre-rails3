# == Schema Information
#
# Table name: servers
#
#  id         :integer          not null, primary key
#  host_name  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Server do
  
  before :all do
    if !@server=Server.find_by_host_name('testserver')
      @server=Server.create! :host_name=>'testserver'
    end
  end
  
  after :all do
    Server.delete_all 
  end
  
  describe 'Should respond to the following methods' do
    it { @server.should respond_to(:host_name) }
  end
  
  describe 'Add New Server' do
    it 'Should allow the addition of a new server' do
      svr=Server.create(:host_name=>'myserver')
      svr.should be_valid
    end
    
    it 'Should not allow the addition of a new server with an existing :host_name' do
      svr=Server.create(:host_name=>'testserver')
      svr.should_not be_valid
    end
  end
  
  describe 'Check Server Model Validations' do
    it 'Is not valid without a hostname' do
      svr=Server.new :host_name=>nil
      svr.should_not be_valid
    end
  
    it 'Should have a host_name < 51 characters long' do
      svr=Server.new :host_name=>'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
      svr.should be_valid
    
      svr=Server.new :host_name=>'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
      svr.should_not be_valid
    end
  
    it 'Host_Name should be unique' do
      svr=Server.new :host_name=>'testserver'
      svr.should_not be_valid
    end
  end
  
end
