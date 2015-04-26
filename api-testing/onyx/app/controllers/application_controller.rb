class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  around_filter :catch_not_found


  def missing
    render json: '{"error": "not_found"}', status: :not_found
  end
  

  private

    def catch_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      puts "test"
      render json: '{"error": "not_found"}', status: :not_found
    end
end
