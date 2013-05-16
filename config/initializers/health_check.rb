HealthCheck.setup do |config|

  # Text output upon success
  config.success = 'success'

  # Timeout in seconds used when checking smtp server
  config.smtp_timeout = 30.0

  # http status code used when plain text error message is output
  # Set to 200 if you want your want to distinguish between partial (text does not include success) and
  # total failure of rails application (http status of 500 etc)

  config.http_status_for_error_text = 500

  # http status code used when an error object is output (json or xml)
  # Set to 200 if you want your want to distinguish between partial (healthy property == false) and
  # total failure of rails application (http status of 500 etc)

  config.http_status_for_error_object = 500

  # Add one or more custom checks that return a blank string if ok, or an error message if there is an error
  #config.add_custom_check do
  #  CustomHealthCheck.perform_check # any code that returns blank on success and non blank string upon failure
  #end

  #def database_check
  #  begin
  #    user = User.find(2)
  #    if user.name == "limin"
  #      return ""
  #    else
  #      return "user's name does not match to user's id"
  #    end
  #  rescue
  #    return "exception"
  #  end
  #end







  #config.add_custom_check do
  #  database_check
  #end
  #
  #def database_check
  #  user = User.find(2)
  #  if user.name == "limin"
  #    return ""
  #  else
  #    return "user's name does not match to user's id"
  #  end
  #end


end