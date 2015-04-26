module Testframework
  module Testprinter

    def self.print testresults
      failed = testresults.select{ |result| result.success != true }
      if failed.count == 0
        puts "All tests pass!".green
      else
        puts "Failed tests: #{failed.count}/#{testresults.count} ".red
        puts "-------------"
        failed.each do |result|
          puts "#{result.name}"
          puts "#{result.verb}   #{result.uri}"
          puts "\t#{result.reason}"
          puts "\tresponse: #{result.code}\n\t\t #{result.body}" if result.body
          puts "\n"
        end
      end
    end
    
  end
end

class String
def black;          "\033[30m#{self}\033[0m" end
def red;            "\033[31m#{self}\033[0m" end
def green;          "\033[32m#{self}\033[0m" end
def brown;          "\033[33m#{self}\033[0m" end
def blue;           "\033[34m#{self}\033[0m" end
def magenta;        "\033[35m#{self}\033[0m" end
def cyan;           "\033[36m#{self}\033[0m" end
def gray;           "\033[37m#{self}\033[0m" end
def bg_black;       "\033[40m#{self}\033[0m" end
def bg_red;         "\033[41m#{self}\033[0m" end
def bg_green;       "\033[42m#{self}\033[0m" end
def bg_brown;       "\033[43m#{self}\033[0m" end
def bg_blue;        "\033[44m#{self}\033[0m" end
def bg_magenta;     "\033[45m#{self}\033[0m" end
def bg_cyan;        "\033[46m#{self}\033[0m" end
def bg_gray;        "\033[47m#{self}\033[0m" end
def bold;           "\033[1m#{self}\033[22m" end
def reverse_color;  "\033[7m#{self}\033[27m" end
end