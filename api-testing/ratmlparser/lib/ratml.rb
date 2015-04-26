require 'psych'
require_relative 'psych/property'
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

 #  # Base class for the RATML properties
	# class Property
	# 	attr_accessor :children

	# 	def initialize
	# 		@children = []
	# 	end
	# end

 #  # Contain api wide values and reference to the top level endpoints
	# class Root < Property
	# 	attr_accessor :title, :version, :baseUri

	# 	def initialize root_data
	# 		super()
	# 		root_data.each do |key, value|
	# 			if key.start_with? "/"
	# 				@children << Resource.new(@baseUri, key, value)
	# 			else
	# 				self.send("#{key}=", value)
	# 			end
	# 		end
	# 	end
	# end

  # Endpoints
	class Resource < Property
		attr_accessor :element, :uri

		def initialize anchor, name, data
			super()
			@uri = anchor + name

      # Collections and elements need to be treated
      # slightly differently
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

  # The possible response status codes
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

  # Input/Output test cases
	class Testcase
		attr_accessor :query, :status, :response, :schema, :name, :id, :dependent

		def initialize name, data
			@name = name			
			@query = JSON.parse data["query"] if data["query"]
			@dependent = data["dependent"] if data["dependent"]
			@status = data["response"]["status"]
			@response = JSON.parse data["response"]["body"]
			@id = data["resource"]

			# A block comparing whether response is equal to the spec
			@schema = lambda{ |response|
				response = JSON.parse response
				return response == @response
			}
		end
	end


  # The main schema body
	class Body < Property
		attr_accessor :media_type, :schema


		def initialize media_type, body_data
			@media_type = media_type
			# Converting strings to ruby types
		  type_hash = { "string" => lambda{ |type| type.is_a? String},
										"uri" => lambda{ |type| type.is_a? String},
									  "long" => lambda{ |type| type.is_a? Integer},
									  "int" => lambda{ |type| type.is_a? Integer} }

			body_data.each do |key, value|
				case key
				when "schema"
					hash = JSON.parse value
					required = hash["required"]
					properties = create_proc_properties hash["properties"]

					# A heuristic algorithm to compare received responses
					# with previous requests to determine if the response
					# is valid
					@schema = lambda{ |response|
						comparator = lambda{ |response, hash|
							if hash[:array]
								response.each do |response|
									unless comparator.call(response, hash[:array])
										return false
									end
								end
							else
								response.each do |key, value|
									if value.is_a? Array
										value.each do |response|
											unless comparator.call(response, hash[key][:array])
												return false
											end
										end
									else
										unless hash.keys.include? key
											return false
										end

										type = hash[key]
										type_proc = type_hash[type]

										unless type_proc.call(value)
											return false
										end
									end
								end
							end
							return true
						}

						hash = JSON.parse response
						comparator.call(hash, properties)
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
					properties[property] = create_proc_properties value
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