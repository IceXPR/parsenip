class WordsController < ApplicationController
  before_filter :restrict_to_api_users
  def index
    render json: {success: true, word: "The Bird"}
  end

  def create
    params[:file]
  end
end
