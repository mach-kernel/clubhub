class EventsController < ApplicationController
  def index
  	@all_events = Event.find_by_sql("SELECT * FROM event")

  	unless validate_user == :not_logged_in
      @my_events = Club.find_by_sql("SELECT * FROM event WHERE eid IN (SELECT eid from sign_up WHERE pid = '#{session[:person]['pid']}')")
    end
  end

  def new
  end

  def hub
    unless params[:id]
      flash[:error] = "You have arrived here in error. It's probably your fault."
      redirect_to '/events/index'
    end
    @event = Event.find_by_sql("SELECT * FROM event WHERE eid = #{params[:id]}").first

    @attending = Person.find_by_sql("SELECT * FROM person WHERE pid IN (SELECT pid from sign_up WHERE eid = '#{params[:id]}')")

    @public_comments = Comment.find_by_sql("SELECT * FROM comment WHERE comment_id IN (SELECT comment_id FROM event_comment WHERE eid = '#{@event.eid}') AND is_public_c = 1")
    @all_comments = Comment.find_by_sql("SELECT * FROM comment WHERE comment_id IN (SELECT comment_id FROM event_comment WHERE eid = '#{@event.eid}')")
  end

  def create
    if params[:commit] == "Create" and params.has_key?("event")
      event = params[:event]

      # Make new event
      newevent = Event.new
      newevent.ename = event[:ename]
      newevent.description = event[:description]
      newevent.edatetime = event[:edatetime]
      newevent.location = event[:location]
      newevent.is_public_e = event[:public]
      newevet.sponsored_by = params[:id]
      newevent.save!

      flash[:notice] = "The #{event[:ename]} event has been created."
      redirect_to "/clubs/hub/#{params[:id]}"
    else
      flash.now[:error] = "Something went wrong. Try again?"
      render "/events/#{params[:id]}/new"
    end    
  end

  def addcomment
    unless params[:id]
      flash[:error] = "You have arrived here in error. It's probably your fault."
      redirect_to '/events/index'
    end

    comment = params[:event_comment]

    newcomment = Comment.new
    newcomment.commenter = session[:person]['pid']
    newcomment.ctext = comment[:ctext]
    newcomment.is_public_c = comment[:public]
    newcomment.save!

    ActiveRecord::Base.connection.execute("INSERT INTO event_comment (comment_id, eid) VALUES ('#{newcomment.comment_id}', '#{params[:id]}')")
    flash[:notice] = "Your comment has been successfully submitted."
    redirect_to "/events/hub/#{params[:id]}"
  end

  def rsvp
    unless params[:id]
      flash[:error] = "You have arrived here in error. It's probably your fault."
      redirect_to '/events/index'
    end
  end

  def edit
  end
end
