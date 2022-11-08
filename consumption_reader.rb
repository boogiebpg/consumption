require 'date'

class ConsumptionReader
  def initialize(filename)
    @filename = filename
  end

  def parse_file
    data = {}
    File.open(@filename, "r") do |file_data|
      file_data.each_line do |line|
        date_string, value = line.split(',')
        next unless date_string || value
        date = Date.parse(date_string).strftime("%Y-%m-%d")
        data[date] = value.to_f
      rescue ArgumentError
        next
      end
    end
    data
  end

end
