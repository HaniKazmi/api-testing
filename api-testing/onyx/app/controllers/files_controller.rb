  class FilesController < ActionController::Base
    def index
      puts "hello"
      render json: Fille.all
    end
  end
