  class UsersController < ApplicationController
    def index
      @Users = User.all
      render 'index.json.erb'
    end

    def create
      @user = User.new name: params[:name], role: params[:role], photo: params[:photo]
      @user.save
      render 'create.json.erb'
    end

    def show
      @user = User.find(params[:id])
      render 'show.json.erb'
    end

    def destroy
      begin
        @user = User.find(params[:id])
        @user.destroy
      rescue
      ensure
        render 'destroy.json.erb'
      end
    end
  end
