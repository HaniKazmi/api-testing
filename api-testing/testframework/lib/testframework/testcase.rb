module Testframework
  class Testcase
    attr_accessor :resource, :method, :schema
    
    def initialize resource, method
      @resource = resource
      @method = method
      @schema = Hash.new
      method.children.each do |response|
        @schema[response.status] = response.body
      end
    end

    def url
      if @resource.element
        @resource.uri
      else
        @resource.uri
      end
    end

    def to_s
      puts "#{@resource} | #{@method.name} | #{@schema}"
    end
  end
end