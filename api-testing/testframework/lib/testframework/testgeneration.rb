require_relative "testcase"

module Testframework
  module Testgenerator

    def self.generate root
      testcases = Array.new
      root.children.each do |resource|
        testcases += self.transform_resource(resource)
      end
      testcases
    end

    def self.transform_resource resource
      testcases = Array.new
      resource.children.each do |child|
        if child.is_a? Ratml::Method
          testcases << Testframework::Testcase.new(resource, child)
        elsif child.is_a? Ratml::Resource
          testcases +=self.transform_resource(child)              
        end
      end
      testcases
    end

  end
end