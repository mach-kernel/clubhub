class UsersController < ApplicationController
  def new
  	render "new"
  end

  # This actually adds the users to the db
  def create
  	if params[:commit] == "Register" and params.has_key?("person")
		
		person = params[:person]
		ActiveRecord::Base.connection.execute(
			"INSERT INTO person (pid, passwd, fname, lname, clubadmin, superuser) VALUES ('#{person[:pid]}', '#{Digest::MD5.hexdigest(person[:passwd])}', '#{person[:fname]}', '#{person[:lname]}', false, false)")

		# Log the user in
		session[:person] = person

		flash[:notice] = "Your account has been successfully created, #{person[:fname]}!"
		redirect_to '/'
  	else
  		flash.now[:notice] = "Something went wrong. Try again?"
  		render "new"
  	end
  end

  def login
    render "login"
  end

  def verify_login
    if params[:commit] == "Log In" and params.has_key?("logon")
      user = Person.find_by_sql("SELECT * FROM person WHERE pid = '#{params[:logon][:pid]}' AND passwd = '#{Digest::MD5.hexdigest(params[:logon][:passwd])}'")
      if user.empty?
        flash[:error] = "I can't find your username and password and it's probably your fault."
        render "login"
      else
        session[:person] = user.first
        flash[:success] = "Welcome, #{user.first.fname}!"
        redirect_to "/"
      end
    else
      flash.now[:notice] = "Something went wrong. Try again?"
      render "new"
    end
  end

  def logout
    reset_session
    flash[:alert] = "You have logged out. Probably because you have better things to do."
    redirect_to "/"
  end
end
