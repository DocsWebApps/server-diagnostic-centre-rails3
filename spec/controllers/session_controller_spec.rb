require 'spec_helper'

describe SessionController do
  before :all do
    FactoryGirl.create(:Role,:name=>'admin',:description=>'Admin Account')
    FactoryGirl.create(:Role,:name=>'user',:description=>'User Account')
    admin_role=Role.find_by_name :admin
    @user=admin_role.users.create(:name=>'TestUser',:email=>'admin@admin.com',:password=>'abc1234',:password_confirmation=>'abc1234')

  end
    
  after :all do
    User.delete_all
    Role.delete_all
  end
    
  describe 'Unit Test for controller method :create' do
    it 'Should authenticate the user admin@admin.com and therefore render view :diagnostic_centre_homepage ' do
      post :create,{:session=>{:email=>"admin@admin.com",:password=> "abc1234"}}
      response.should render_template('diagnostic_centre_homepage')
    end
    
    it 'Should NOT authenticate the user admin1234@admin.com (different email) and therefore render view :diagnostic_centre_signinpage ' do
      post :create,{:session=>{:email=>"admin1234@admin.com",:password=> "abc1234"}}
      response.should render_template('diagnostic_centre_signinpage')
    end
    
    it 'Should NOT authenticate the user admin@admin.com (wrong password) and therefore render view :diagnostic_centre_signinpage ' do
      post :create,{:session=>{:email=>"admin@admin.com",:password=> "abc12345"}}
      response.should render_template('diagnostic_centre_signinpage')
    end
  end
  
  describe 'Unit Test for controller method :update' do
    it 'Should allow a user to change their password' do   
      post :create,{:session=>{:email=>"admin@admin.com",:password=> "abc1234"}}   
      post :change_password,{:session=>{:old_password=>'abc1234',:new_password=>'zyx1234',:confirmation=>'zyx1234'}}
      response.should render_template('diagnostic_centre_homepage') 
    end
  end
  
  describe 'Unit Test for controller method :add_user' do
    it 'Should allow an admin to add a user' do    
      post :create,{:session=>{:email=>"admin@admin.com",:password=> "abc1234"}} 
      post :add_user,{:session=>{:role=>'user',:name=>'Test User1',:email=>'testuser1@mail.com',:password=>'testuser1',:password_confirmation=>'testuser1'}}  
      response.should render_template('diagnostic_centre_homepage') 
    end
  end
  
  describe 'Unit Test for controller method :add_server' do
    it 'Should allow an admin to add a server' do   
      post :create,{:session=>{:email=>"admin@admin.com",:password=> "abc1234"}} 
      post :add_server,{:session=>{:host_name=>'testserver2'}}  
      response.should render_template('diagnostic_centre_homepage')  
    end
  end
end 
