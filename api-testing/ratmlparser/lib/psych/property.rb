module Ratml
  # Contain api wide values and reference to the top level endpoints
    # Base class for the RATML properties
  class Property
    attr_accessor :children

    def initialize
      @children = []
    end
  end
end