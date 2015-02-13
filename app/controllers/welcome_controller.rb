class WelcomeController < ApplicationController 
  #before_filter :restrict_to_xhr

  def index
    if request.xhr?
      render json: {success: true}
    end
  end
end
