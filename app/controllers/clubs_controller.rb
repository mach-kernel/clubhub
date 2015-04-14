class ClubsController < ApplicationController

  def index
    @all_clubs = Club.find_by_sql("SELECT * FROM club")

    unless validate_user == :not_logged_in
      @my_clubs = Club.find_by_sql("SELECT * FROM club WHERE clubid IN (SELECT clubid from member_of WHERE pid = '#{session[:person]['pid']}')")
    end

  	render "index"
  end

  def new
  	render "new"
  end

  def hub
    unless params[:id]
      flash[:error] = "You have arrived here in error. It's probably your fault."
      redirect_to '/clubs/index'
    end
    @club = Club.find_by_sql("SELECT * FROM club WHERE clubid = #{params[:id]}").first

    @students = Person.find_by_sql("SELECT * FROM person WHERE pid IN (SELECT pid from member_of WHERE clubid = '#{@club.clubid}')")
    
    # This sucks but I don't want to tokenize a large query string and I won't get fired for doing this so why not
    @students.each do |student|
      student.role = Role_in.find_by_sql("SELECT * FROM role_in WHERE pid = '#{student.pid}' AND clubid = '#{params[:id]}'").first.role
    end

    @club_events = Event.find_by_sql("SELECT * FROM event WHERE sponsored_by = '#{params[:id]}'")

    @advisors = Person.find_by_sql("SELECT * FROM person WHERE pid IN (SELECT pid from advisor_of WHERE clubid = '#{@club.clubid}')")

    @public_comments = Comment.find_by_sql("SELECT * FROM comment WHERE comment_id IN (SELECT comment_id FROM club_comment WHERE clubid = '#{@club.clubid}') AND is_public_c = 1")
    @all_comments = Comment.find_by_sql("SELECT * FROM comment WHERE comment_id IN (SELECT comment_id FROM club_comment WHERE clubid = '#{@club.clubid}')")
  end

  # Professor, I know you want a query here but it is a massive pain
  # in the rear end to get the ID of the thing which was just inserted
  # if I want to use autoincrement. I could find the last ID but that's a concurrency issue
  # and blah blah best practices. I could queue everything up but that's bad design.
  def create
  	if params[:commit] == "Create" and params.has_key?("club")
  		club = params[:club]

      # Make new club
      newclub = Club.new
      newclub.cname = club[:cname]
      newclub.descr = club[:descr]
      newclub.save!

      # Add keywords
      ActiveRecord::Base.connection.execute("INSERT INTO keywords (topic) VALUES ('#{club[:topics]}')")

      # Assign current user the role of "founder" and make them a member
      # of the club which they have just created
      ActiveRecord::Base.connection.execute("INSERT INTO member_of (pid, clubid) VALUES ('#{session[:person]['pid']}', '#{newclub.clubid}') ")
      ActiveRecord::Base.connection.execute("INSERT INTO role_in (pid, clubid, role) VALUES ('#{session[:person]['pid']}', '#{newclub.clubid}', 'Founder') ")

  		flash[:notice] = "The #{club[:cname]} club has been created."
  		redirect_to '/'
  	else
  		flash.now[:error] = "Something went wrong. Try again?"
  		render "new"
  	end
  end

  def addcomment
    unless params[:id]
      flash[:error] = "You have arrived here in error. It's probably your fault."
      redirect_to '/clubs/index'
    end

    comment = params[:club_comment]

    newcomment = Comment.new
    newcomment.commenter = session[:person]['pid']
    newcomment.ctext = comment[:ctext]
    newcomment.is_public_c = comment[:public]
    newcomment.save!

    ActiveRecord::Base.connection.execute("INSERT INTO club_comment (comment_id, clubid) VALUES ('#{newcomment.comment_id}', '#{params[:id]}')")
    flash[:notice] = "Your comment has been successfully submitted."
    redirect_to "/clubs/hub/#{params[:id]}"
  end

  def add_students
    unless params[:id]
      flash[:error] = "You have arrived here in error. It's probably your fault."
      redirect_to '/clubs/index'
    end

    student = params[:student]

    check_students = Person.find_by_sql("SELECT * from person WHERE pid IN (SELECT pid FROM student WHERE pid = '#{student[:pid]}')")

    if check_students.length < 1
      flash[:error] = "Username not found. Try again."
      redirect_to "/clubs/hub/#{params[:id]}"
    else
      ActiveRecord::Base.connection.execute("INSERT INTO member_of (pid, clubid) VALUES ('#{student[:pid]}', '#{params[:id]}') ")
      ActiveRecord::Base.connection.execute("INSERT INTO role_in (pid, clubid, role) VALUES ('#{student[:pid]}', '#{params[:id]}', '#{student[:role]}') ")

      flash[:notice] = "Student added successfully!"
      redirect_to "/clubs/hub/#{params[:id]}"
    end
  end

  def add_advisors
    unless params[:id]
      flash[:error] = "You have arrived here in error. It's probably your fault."
      redirect_to '/clubs/index'
    end

    advisor = params[:advisor]
    
    check_advisors = Person.find_by_sql("SELECT * from person WHERE pid IN (SELECT pid FROM advisor WHERE pid = '#{student[:pid]}')")

    if check_students.length < 1
      flash[:error] = "Username not found. Try again."
      redirect_to "/clubs/hub/#{params[:id]}"
    else
      ActiveRecord::Base.connection.execute("INSERT INTO advisor_of (pid, clubid) VALUES ('#{student[:pid]}', '#{params[:id]}') ")

      flash[:notice] = "Advisor added successfully!"
      redirect_to "/clubs/hub/#{params[:id]}"
    end
  end

  def drop_students
    unless params[:id]
      flash[:error] = "You have arrived here in error. It's probably your fault."
      redirect_to '/clubs/index'
    end
    if validate_user != :superuser && validate_user != :clubadmin && !local_club_admin?
      flash[:error] = "You are not clever at all. #{local_club_admin?}"
      redirect_to "/clubs/hub/#{params[:id]}"
    else
      student = params[:student]
      ActiveRecord::Base.connection.execute("DELETE FROM role_in WHERE pid = '#{student[:pid]}' AND clubid = '#{params[:id]}'")
      ActiveRecord::Base.connection.execute("DELETE FROM member_of WHERE pid = '#{student[:pid]}' AND clubid = '#{params[:id]}'")
      flash[:error] = "Student dropped!"

      redirect_to "/clubs/hub/#{params[:id]}"
    end
  end

  def drop_advisors
    unless params[:id]
      flash[:error] = "You have arrived here in error. It's probably your fault."
      redirect_to '/clubs/index'
    end
    if validate_user != :superuser && validate_user != :clubadmin && !local_club_admin?
      flash[:error] = "You are not clever at all."
      redirect_to "/clubs/hub/#{params[:id]}"
    else
      advisor = params[:advisor]
      ActiveRecord::Base.connection.execute("DELETE FROM advisor_of WHERE pid = '#{advisor[:pid]}' AND clubid = '#{params[:id]}'")
      flash[:error] = "Advisor dropped!"

      redirect_to "/clubs/hub/#{params[:id]}"
    end
  end

  def manage
    @all_clubs = Club.find_by_sql("SELECT * FROM club")
  end

  def edit
    if validate_user != :superuser && validate_user != :clubadmin && !local_club_admin?
      flash[:error] = "You are not clever at all."
      redirect_to "/"
    else
      club = params[:club]
      editedclub = Club.find_by_sql("SELECT * from club WHERE clubid = '#{club[:clubid]}'").first

      unless club[:cname].empty? 
        editedclub.cname = club[:cname]
      end

      unless club[:descr].empty?
        editedclub.descr = club[:descr]
      end

      editedclub.save!

      flash[:notice] = "Club edited!"
      redirect_to "/clubs/manage"
    end
  end
end
