require_relative "consumption_reader"
require_relative "consumption_calculator"

filename = ARGV[0]
unless filename
  puts "Please provide a file name as argument."
  return
end

reader = ConsumptionReader.new(filename)
available_data = reader.parse_file

calculator = ConsumptionCalculator.new(available_data)
p calculator.process!
