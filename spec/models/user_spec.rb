# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  role_id         :integer
#

require 'spec_helper'

describe User do
  
  before :all do
    FactoryGirl.create :Role,:name=>'admin',:description=>'Admin Role'
    FactoryGirl.create :Role,:name=>'user',:description=>'Basic User Role'
    admin_role=Role.find_by_name 'admin'
    usr=admin_role.users.create :name=>'testname',:email=>'test@testmail.com',:password=>'testpassword',:password_confirmation=>'testpassword'
    @user=User.find_by_email 'test@testmail.com'
  end
  
  after :all do
    User.delete_all 
  end
  
  describe 'Should respond to the following methods' do
    it { @user.should respond_to(:name) }
    it { @user.should respond_to(:email) }
    it { @user.should respond_to(:password_digest) }
    it { @user.should respond_to(:password) }
    it { @user.should respond_to(:password_confirmation) }
  end
  
  describe 'Update Password' do
    it 'Should allow a user to update their password' do
      @user.change_password('newpassword')
    end
  end
  
  describe 'Add New User' do
    it 'Should allow addition of a new user' do
      user=User.create(:name=>'myname',:email=>'myname@mail.com',:password=>'myname0001',:password_confirmation=>'myname0001')
      user.should be_valid
    end
    
   it 'Should not allow addition of a new user with an existing email' do
      user=User.create(:name=>'myname',:email=>'test@testmail.com',:password=>'myname0001',:password_confirmation=>'myname0001')
      user.should_not be_valid
    end
  end
  
  describe 'Check User Model Validations' do
    
    it 'User is s not valid without a :name' do
      user=User.new :name=>nil
      user.should_not be_valid
    end
    
    it 'User is s not valid without an :email' do
      user=User.new :email=>nil
      user.should_not be_valid
    end
    
    it 'User is s not valid without a :password' do
      user=User.new :password=>nil
      user.should_not be_valid
    end    

    it 'User is s not valid without a :password_confirmation' do
      user=User.new :password_confirmation=>nil
      user.should_not be_valid
    end    
  
    it 'Should have a :name < 51 characters long' do
      user=User.new :name=>'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',:email=>'test1@testmail.com',:password=>'testpassword',:password_confirmation=>'testpassword'
      user.should be_valid
    
      user=User.new :name=>'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',:email=>'test1@testmail.com',:password=>'testpassword',:password_confirmation=>'testpassword'
      user.should_not be_valid
    end

    it 'Should have a :password > 7 characters long' do
      user=User.new :name=>'Test User',:email=>'test2@testmail.com',:password=>'1234567',:password_confirmation=>'1234567'
      user.should be_valid
    
      user=User.new :name=>'Test User',:email=>'test2@testmail.com',:password=>'123456',:password_confirmation=>'123456'
      user.should_not be_valid
    end
      
    it 'User :email should be unique' do
      user=User.new :name=>'testname'
      user.should_not be_valid
    end
    
    it 'Email should conform to the following REGEX (/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)' do
      user=User.new :name=>'Test User',:email=>'test2@testmail.com',:password=>'1234567',:password_confirmation=>'1234567'
      user.should be_valid
    
      user=User.new :name=>'Test User',:email=>'12345',:password=>'123456',:password_confirmation=>'123456'
      user.should_not be_valid
      
      user=User.new :name=>'Test User',:email=>'12345@12345',:password=>'123456',:password_confirmation=>'123456'
      user.should_not be_valid
      
      user=User.new :name=>'Test User',:email=>'12345.com',:password=>'123456',:password_confirmation=>'123456'
      user.should_not be_valid      
    end
  end
 
end
