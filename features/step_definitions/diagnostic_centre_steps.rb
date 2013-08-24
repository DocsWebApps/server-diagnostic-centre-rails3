Given /^the following users exist:/ do |user_table|
  user_table.hashes.each do |user|
    user_role=Role.find_by_name user['role']
    if !user_role
      user_role=Role.create :name=>user['role'],:description=>user['description'] 
    end  
    user=user_role.users.create :name=>user['name'],:email=>user['email'],:password=>user['password'],:password_confirmation=>user['password']
  end
end
 
When /^I log into the Server Diagnostic Centre as user "(.*?)" with password "(.*?)"/  do |user,password|
  visit path_to('the Server Diagnostic Centre Login page')
  fill_in('session_email', :with=>user)
  fill_in('session_password', :with=>password)
  click_button('login-button')
end

When /^I select the tool "(.*?)"/ do |tool_name|
  select(tool_name, :field=>'selectTool')
  visit path_to("the #{tool_name} Homepage")
end

When(/^I enter the old password "(.*?)", a new password "(.*?)", a confirmation "(.*?)" and submit the request$/) do |old_password, new_password, confirmation|
  fill_in('old_password', :with=>old_password)
  fill_in('new_password', :with=>new_password)
  fill_in('confirmation', :with=>confirmation)
  click_button('change-password-button')
end

When(/^I enter "(.*?)" "(.*?)", "(.*?)", "(.*?)", "(.*?)" and "(.*?)" and press the add new user submit button$/) do |dummy,user_name, email,password,confirmation,role|
  fill_in('name', :with=>user_name)
  fill_in('email', :with=>email)
  fill_in('password', :with=>password)
  fill_in('confirmation', :with=>confirmation)
  select(role, :field=>'role')
  click_button('add-user-button')
end

When(/^I enter "(.*?)" "(.*?)" and press the add new server submit button$/) do |dummy,host_name|
  fill_in('host_name', :with=>host_name)
  click_button('add-server-button')
end