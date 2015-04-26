module Ratml
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
end