module Ratml
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