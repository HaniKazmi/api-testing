module Ratml
  # Input/Output test cases
  class Testcase
    attr_accessor :query, :status, :response, :schema, :name, :id, :dependent

    def initialize name, data
      @name = name      
      @query = JSON.parse data["query"] if data["query"]
      @dependent = data["dependent"] if data["dependent"]
      @status = data["response"]["status"]
      @response = JSON.parse data["response"]["body"]
      @id = data["resource"]

      # A block comparing whether response is equal to the spec
      @schema = lambda{ |response|
        response = JSON.parse response
        return response == @response
      }
    end
  end

end