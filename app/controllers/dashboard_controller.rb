class DashboardController < ApplicationController
  before_filter :redirect_if_not_logged_in
  def index
    @user = current_user
  end
end
