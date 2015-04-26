  class UsersController < ActionController::Base
    def index
      @Users = User.all
      render 'index.json.erb'
    end
  end
