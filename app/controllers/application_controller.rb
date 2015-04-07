class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # We need security. This should do it. 
  helper_method :validate_user
  def validate_user
    if session.key?(:person)
      user = Person.find_by_sql("SELECT clubadmin, superuser FROM person WHERE pid = '#{session[:person]['pid']}'")
      if user.empty?
        :not_logged_in
      else
        if user.first.superuser
          :superuser
        elsif user.first.clubadmin
          :clubadmin
        else
          :user
        end
      end
    else
      :not_logged_in
    end
  end
end
