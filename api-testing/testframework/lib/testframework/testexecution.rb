require_relative "testcase"
require_relative "../typhoeus/lib/typhoeus"

module Testframework
  module Testexecutor

    def self.execute testcases
    testcase = testcases.first
      # testcases.each do |testcase|
        request = Typhoeus.get(testcase.url)
        puts testcase.schema[request.code].schema.call(request.body)
    end
  end
end