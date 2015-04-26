module Ratml
  # Contain api wide values and reference to the top level endpoints
    # Base class for the RATML properties
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


end