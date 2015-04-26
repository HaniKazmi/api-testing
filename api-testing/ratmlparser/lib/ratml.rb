require 'psych'
require_relative 'psych/property'
require_relative 'psych/root'
require_relative 'psych/resource'
require_relative 'psych/method'
require_relative 'psych/testcase'
require_relative 'psych/response'
require_relative 'psych/body'

require 'json'

module Ratml

	###
	# Load +ratml+ in to a Ruby data structure.
	#	 
	def self.load ratml
		Ratml::Parser.new ratml
	end

	def self.load_file filename
		file = File.new(filename)
    	self.load(file.read)
    end

	class Parser
		attr_accessor :data

		def initialize data
			@data = Psych.load data
		end

	  # Start recursive decent of the syntax tree
		def parse
			@root = Root.new @data
		end
	end
	
end