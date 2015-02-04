require 'yaml'

module Raml
	def self.load raml
		Raml::Parser.new raml
	end

	def self.load_file filename
		file = File.new(filename)
    	self.load(file.read)
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
				else
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
				case key
				when 'responses'
					value.each do |name, response_data|
						@children << Response.new(name, response_data)
					end
				end
			end
		end
	end

	class Response < Property
		def initialize name, data
			super()
			data.each do |key, value|
				case key
				when 'body'
					value.each do |name, body_data|
						@children << Body.new(name, body_data)
					end
				end
			end
		end
	end

	class Body < Property
		attr_accessor :media_type, :schema

		def initialize media_type, body_data
			@media_type = media_type
			body_data.each do |key, value|
				send("#{key}=", value)
			end
		end
	end
end