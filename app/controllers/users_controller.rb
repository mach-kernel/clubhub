class UsersController < ApplicationController
  def new_student
    render "new_student"
  end

  # This actually adds the users to the db
  def create_student
  	if params[:commit] == "Register" and params.has_key?("person")
		
		person = params[:person]
		ActiveRecord::Base.connection.execute(
			"INSERT INTO person (pid, passwd, fname, lname, clubadmin, superuser) VALUES ('#{person[:pid]}', '#{Digest::MD5.hexdigest(person[:passwd])}', '#{person[:fname]}', '#{person[:lname]}', false, false)")

    ActiveRecord::Base.connection.execute(
      "INSERT INTO student (pid, gender, class) VALUES ('#{person[:pid]}', '#{person[:gender]}', '#{person[:class]}')")

		# Log the user in
		session[:person] = person.except!(:passwd)

		flash[:notice] = "Your account has been successfully created, #{person[:fname]}!"
		redirect_to '/'
  	else
  		flash.now[:error] = "Something went wrong. Try again?"
  		render "new"
  	end
  end

  def create_advisor
    if params[:commit] == "Register" and params.has_key?("person")
    
    person = params[:person]
    ActiveRecord::Base.connection.execute(
      "INSERT INTO person (pid, passwd, fname, lname, clubadmin, superuser) VALUES ('#{person[:pid]}', '#{Digest::MD5.hexdigest(person[:passwd])}', '#{person[:fname]}', '#{person[:lname]}', false, false)")

    ActiveRecord::Base.connection.execute(
      "INSERT INTO advisor (pid, phone) VALUES ('#{person[:pid]}', '#{person[:phone]}')")

    # Log the user in
    session[:person] = person.except!(:passwd)

    flash[:notice] = "Your account has been successfully created, #{person[:fname]}!"
    redirect_to '/'
    else
      flash.now[:error] = "Something went wrong. Try again?"
      render "new"
    end
  end

  def edit
    if validate_user != :superuser
      flash[:error] = "You are not clever at all."
      redirect_to '/'
    end
    if params.has_key?("person")
      person = params[:person]
      user = Person.find_by_sql("SELECT * FROM person where pid = '#{person[:pid]}'").first

      if params[:commit] == "Save"
        # Update fields
        user.clubadmin = person[:clubadmin]
        user.superuser = person[:superuser]
        unless person[:passwd].empty?
          user.passwd = Digest::MD5.hexdigest(person[:passwd])
        end 

        user.save!
        flash[:notice] = "Updated person #{person[:pid]} successfully!"
      elsif params[:commit] == "Delete"
        user.destroy!
        flash[:error] = "Deleted #{person[:pid]} successfully! Very sad."
      end
      redirect_to '/dashboard/admin'
    end
  end

  def login
    render "login"
  end

  def verify_login
    if params[:commit] == "Log In" and params.has_key?("logon")
      user = Person.find_by_sql("SELECT fname, lname, clubadmin, superuser, pid FROM person WHERE pid = '#{params[:logon][:pid]}' AND passwd = '#{Digest::MD5.hexdigest(params[:logon][:passwd])}'")
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
