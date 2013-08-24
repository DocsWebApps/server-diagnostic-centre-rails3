# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Role do
  
  before :all do
    FactoryGirl.create :Role,:name=>'testname1',:description=>'Test Role1'
    @role=Role.find_by_name('testname1')
  end
  
  after :all do
    Role.delete_all 
  end
  
  describe 'Should respond to the following methods' do
    it { @role.should respond_to(:name) }
  end
  
  describe 'Add New Role' do
    it 'Should allow the addition of a new role' do
      role=Role.create(:name=>'myrole',:description=>'myrole')
      role.should be_valid
    end
    
    it 'Should not allow the addition a new role with an existing :name' do
      role=Role.create(:name=>'testname1',:description=>'myrole')
      role.should_not be_valid
    end
  end
  
  describe 'Check Role Model Validations' do
    it 'Role is not valid without a :name' do
      role=Role.new :name=>nil
      role.should_not be_valid
    end
   
    it 'Role :name should be unique' do
      role=Role.new :name=>'testname1'
      role.should_not be_valid
    end

  end
end
