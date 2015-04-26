require 'psych'
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
					@children << Resource.new(@baseUri, key, value)
				else
					self.send("#{key}=", value)
				end
			end
		end
	end

	class Resource < Property
		attr_accessor :element, :uri

		def initialize anchor, name, data
			super()
			@uri = anchor + name

			if name[1] == "{"
				@element = true
			end

			data.each do |key, value|
				if key.start_with? "/"
					@children << Resource.new(@uri, key, value)
				else
					@children << Method.new(key, value)
				end
			end
		end
	end

	class Method < Property
		attr_accessor :name

		def initialize name, data
			super()
			@name = name
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
		attr_accessor :status, :body
		def initialize name, data
			super()
			@status = name
			data.each do |key, value|
				case key
				when 'body'
					value.each do |name, body_data|
						@children << Body.new(name, body_data)
					end
				end
			end

			@body = @children.first

		end
	end

	class Body < Property
		attr_accessor :media_type, :schema

		def initialize media_type, body_data
			@media_type = media_type
			body_data.each do |key, value|
				case key
				when "schema"
					hash = JSON.parse value
					required = hash["required"]
					properties = create_proc_properties hash["properties"]
					@schema = lambda{ |response|
						hash = JSON.parse response
						if hash.class == Array
							hash = hash.first
							properties = properties[:array]
						end
						hash.each do |key, value|
							unless properties.keys.include? key
								return false
							end
						end
						return true 
					}	
				end
			end
		end

		def create_proc_properties root
			properties = Hash.new
			root.each do |property, value|
				if property.is_a? Hash
					properties[:array] = create_proc_properties property						
				elsif value.is_a? Array
					properties[:array] = create_proc_properties value
				elsif value["type"]
					properties[property] = value["type"]
				else
					properties[property] = create_proc_properties value
				end
			end
			properties
		end

	end

end