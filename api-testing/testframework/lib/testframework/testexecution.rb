require_relative "testcase"
require_relative "testresult"
require_relative "../typhoeus/lib/typhoeus"

module Testframework
  module Testexecutor

    def self.execute testcases
      results = Array.new    
      testcases.each do |testcase|
        result = Testframework::Testresult.new()
        result.uri = testcase.url
        result.verb = testcase.verb
        result.name = testcase.name

        request = Typhoeus.send testcase.verb, testcase.url, body: testcase.body
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
          result.success = testcase.status == request.code and testcase.schema.call request.body
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
        results << result
      end

      puts ""
      results
    end

  end
end