require 'yaml'

module Raml
	def self.load raml
		Raml::Parser.new raml
	end

	def self.load_file filename
		file = File.new(filename)
    	Raml::Parser.new(file.read)
    end


	class Parser
		attr_accessor :data

		def initialize data
			@data = YAML.load data
		end

		def parse
			@root = Root.new @data
		end
	end

	class Property
		attr_accessor :children

		def initialize
			@children = []
		end
	end

	class Root < Property
		attr_accessor :title, :version, :baseUri

		def initialize root_data
			super()
			root_data.each do |key, value|
				if key.start_with? "/"
					@children << Resource.new(key, value)
				else key.start_with? "/"
					self.send("#{key}=", value)
				end
			end
		end
	end

	class Resource < Property
		def initialize name, data
			super()
			data.each do |key, value|
				if key.start_with? "/"
					@children << Resource.new(key, value)
				else
					@children << Method.new(key, value)
				end
			end
		end
	end

	class Method < Property
		def initialize name, data
			super()
			data.each do |key, value|
				@children << value
			end
		end
	end
end