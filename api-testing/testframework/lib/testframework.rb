require_relative '../../ratmlparser/lib/ratml'
require_relative "Testframework/testgeneration"
require_relative 'Testframework/Testexecution'

module Testframework
	def self.test filename
    ratml = Ratml.load_file(filename).parse
    testcases = Testframework::Testgenerator.generate ratml
    testresults = Testframework::Testexecutor.execute testcases
	end
end