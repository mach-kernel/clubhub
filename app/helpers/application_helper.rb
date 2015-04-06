module ApplicationHelper
  # Makes use of standard Rails flash levels with
  # Bootstrap a little easier
  # constantized for ultimate premature optimization

  BOOTSTRAP_CLASSES = {
    "success" => "alert-success",
    "error" => "alert-danger",
    "alert" => "alert-warning",
    "notice" => "alert-info"
  }

  def bootstrap_class_for(flash_level)
  	BOOTSTRAP_CLASSES[flash_level] || flash_level.to_s
  end

  # Instead of including code for lookup under every view,
  # we can just call this function by passing in the session
  # object which will tell us all we need

  def validate_user(session)
    if session.has_key?("person")
      user = Person.find_by_sql(
        "SELECT clubadmin, superuser FROM person WHERE pid = '#{session[:person][:pid]}'")
      p user
      if user.empty?
        :not_logged_in
      else
        if user.clubadmin
          :clubadmin
        elsif user.superuser
          :superuser
        else
          :user
        end
      end
    else
      :not_logged_in
    end
  end

end
