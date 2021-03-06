class DashboardController < ApplicationController

  require 'fortune_gem'

  def index
    @fortune = FortuneGem.give_fortune({:max_length => 200})
    @clubs = Club.count
    @comments = Comment.count
    @users = Person.count
    @events = Event.count
  end

  def admin
  	if validate_user != :superuser
  		flash[:error] = "You are not clever at all."
  		redirect_to '/'
  	else
  		# TODO: non-ghetto version of this with AJAX 
  		# but since a total of 5 people will use this 
  		# it doesn't really matter
  		@all_users = Person.find_by_sql("SELECT * FROM person")
  	end
  end
end
