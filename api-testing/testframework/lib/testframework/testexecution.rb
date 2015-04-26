require_relative "testcase"
require_relative "testresult"
require_relative "../typhoeus/lib/typhoeus"

module Testframework
  module Testexecutor

    def self.execute testcases
      @results = Array.new    
      testcases, dependecies = create_dependencies_hash testcases
      @hydra = Typhoeus::Hydra.hydra

      #Create and run parallized requests
      testcases.each do |testcase|
        @hydra.queue(self.create_request(testcase, dependecies))
        @hydra.run
      end

      puts ""
      @results
    end

    # Recursively parse dependecy lists and add requests to the
    # completion handlers
    def self.create_request testcase, dependecies
      request = Typhoeus::Request.new(
        testcase.url,
        method: testcase.verb,
        body: testcase.body
      )

      request.on_complete do |response| 
        self.handle_response response, testcase
        if dependecies[testcase.name].count > 0
          dependecies[testcase.name].each do |dependent|
            @hydra.queue(self.create_request(dependent, dependecies))
          end
        end
      end
        
      request
    end

    # Massage the response into a usable fromat
    def self.handle_response request, testcase
      result = Testframework::Testresult.new()
        result.uri = testcase.url
        result.verb = testcase.verb
        result.name = testcase.name
        result.code = request.code
        result.body = request.body

        if testcase.is_a? Testframework::Schematestcase  

          response = testcase.schema[request.code]
          if response
            result.success = response.schema.call(request.body)
            unless result.success
              result.reason = "Schema does not match response."
            end
          else
            if request.code == 404
              result.reason = "Endpoint not implemented"
            else
              result.reason = "Schema does not exist for the received status code"
            end
          end

        elsif testcase.is_a? Testframework::Inputtestcase
          result.success = testcase.schema.call(request.body) and ( testcase.status == request.code)
          unless result.success
            result.reason = "Response does not match testcase"
            if testcase.status != request.code
              result.reason = "Wrong status code"
            end
          end
        end

        if result.success
          print 'P'.green
        else
          print 'F'.red
        end
        $stdout.flush
        @results << result
      end

    def self.create_dependencies_hash testcases
      dependecies = Hash.new { |h, k| h[k] = [] }
      testcases.each do |testcase|
        if dependent = testcase.dependent
          dependecies[dependent] << testcase
          testcases.delete testcase
        end
      end
      return testcases, dependecies
    end

  end
end