class SessionController < ApplicationController
  # This controller handles user logins. Written by Dave Collier @29/11/2012
  # A users credentials are authenticated against those stored in the backend DB and if they match the user is directed to the home page.
  # If they don't match then the user is directed back to the signin page and a message is flashed onto the page.
  #
  # Associated Models: 
  # => User
  #
  # Associated Views:
  # => diagnostic_centre_homepage.html.erb; diagnostic_centre_signinpage.html.erb
  
  def create
    # Take the users credentials provided and authenticate them against those stored in the DB
    @user = User.find_by_email(params[:session][:email].downcase)
    if (@user && @user.authenticate(params[:session][:password]))
      session[:remember_token] = @user.id
      render 'diagnostic_centre_homepage'
    else
      flash.now[:error]='Invalid email / password combination'
      render 'diagnostic_centre_signinpage'
    end
  end
  
  def change_password
    @user=User.find_by_id session[:remember_token] 
    new_password=params[:session][:new_password]
    if (@user && @user.authenticate(params[:session][:old_password]) && new_password==params[:session][:confirmation])
      @user.change_password new_password
      flash.now[:success]='Password change successful!'
    else
      flash.now[:error]='A problem occurred, please retry!'
    end
    render 'diagnostic_centre_homepage'
  end
  
  def add_user
    @user=User.find_by_id session[:remember_token]
    email=params[:session][:email]
    email_check=User.find_by_email email
    if (@user.role.name.to_sym == :admin && !email_check)
      new_user_role=Role.find_by_name params[:session][:role]
      new_user=new_user_role.users.create :name=>params[:session][:name],:email=>params[:session][:email],:password=>params[:session][:password],:password_confirmation=>params[:session][:confirmation] 
      flash.now[:success]='New user added successfully!'
    else
      flash.now[:error]='A problem occurred, please retry!'
    end
    render 'diagnostic_centre_homepage'
  end
  
  def add_server
    @user=User.find_by_id session[:remember_token]
    server_name=params[:session][:host_name]
    server_check=Server.find_by_host_name server_name
    if (@user.role.name.to_sym == :admin && !server_check)
      Server.create :host_name=>server_name
      flash.now[:success]='New server added successfully!'
    else
      flash.now[:error]='A problem occurred, please retry!'
    end
    render 'diagnostic_centre_homepage'
  end
  
end