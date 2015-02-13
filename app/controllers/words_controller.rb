class WordsController < ApplicationController
  before_filter :api_authenticate
  def index
    render json: {success: true, word: "The Bird"}
  end
end
