  class FilesController < ApplicationController
    def index
      @Files = Fille.all
      render 'index.json.erb'
    end

    def show
      @file = Fille.find(params[:id])
      render 'show.json.erb'
    end

    def destroy
      begin
        @file = Fille.find(params[:id])
        @file.destroy
      rescue
      ensure
        render 'destroy.json.erb'
      end
    end
  end
