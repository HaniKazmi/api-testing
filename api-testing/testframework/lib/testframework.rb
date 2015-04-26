require_relative '../../ratmlparser/lib/ratml'
require_relative "Testframework/testgeneration"
require_relative 'Testframework/Testexecution'
require_relative 'Testframework/Testprinting'

module Testframework
	def self.test filename, log
    ratml = Ratml.load_file(filename).parse
    testcases = Testframework::Testgenerator.generate ratml
    testresults = Testframework::Testexecutor.execute testcases
    Testframework::Testprinter.print testresults, log
	end
end