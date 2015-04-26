require_relative "testframework/lib/testframework"

if filename = ARGV[0]
  if ARGV[1] = "-l"
    Testframework.test filename, ARGV[2]
  else
    Testframework.test filename
  end
else
  puts "Usage: ruby testframework.rb specification.ratml [-l results.log]"
end