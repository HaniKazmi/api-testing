module Testframework
  class Testcase
    attr_accessor :resource, :method, :schema, :body, :name, :dependent

    def url
      @resource.uri
    end

    def verb
      @method.name
    end

    def to_s
      puts "#{@resource} | #{@method.name} | #{@schema}"
    end
  end

  class Schematestcase < Testcase

    def initialize resource, method
      @name = "Schema"
      @resource = resource
      @method = method
      @schema = Hash.new
      method.children.each do |response|
        if response.is_a? Ratml::Response
          @schema[response.status] = response.body
        end
      end
    end

    def url
      if @resource.element
        @resource.uri.sub /\{.*\}/, '4323' 
      else
        @resource.uri
      end
    end

  end

  class Inputtestcase < Testcase

    def initialize resource, method, testcase
      @name = testcase.name
      @resource = resource
      @method = method
      @schema =  testcase.schema
      @body = testcase.query
      @testcase = testcase
      @dependent = testcase.dependent
    end

    def status
      @testcase.status
    end

    # Substitute in the element id
    def url
      if @resource.element
        @resource.uri.sub /\{.*\}/, @testcase.id.to_s
      else
        @resource.uri
      end
    end
  end
end