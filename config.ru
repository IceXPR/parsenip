# This file is used by Rack-based servers to start the application.

#\ -b 0.0.0.0

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
