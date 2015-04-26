module Ratml
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
end