class ClubsController < ApplicationController
  def index
    @all_clubs = Club.find_by_sql("SELECT * FROM club")
    @my_clubs = Club.find_by_sql("SELECT * FROM club WHERE clubid IN (SELECT clubid from member_of WHERE pid = '#{session[:person]['pid']}')")
  	render "index"
  end

  def new
  	render "new"
  end

  def hub
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

  def edit
  end
end
