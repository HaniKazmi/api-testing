module Ratml
  # HTTP verbs
  class Method < Property
    attr_accessor :name, :cases

    def initialize name, data
      super()
      @name = name
      @cases = Array.new
      data.each do |key, value|
        case key
        when 'responses'
          value.each do |name, response_data|
            @children << Response.new(name, response_data)
          end
        when 'testcases'
          value.each do |name, test_case|
            @cases << Testcase.new(name, test_case)
          end
        end
      end
    end
  end
end