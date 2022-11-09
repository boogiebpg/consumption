require 'date'

class ConsumptionCalculator

  attr_accessor :data

  def initialize(data)
    @data = data
  end

  def process!
    data_array = data.sort
    count = data_array.count
    (0...count - 1).each do |c|
      fill_gaps(data_array[c], data_array[c + 1])
    end
    fill_before_period
    fill_after_period
    consumption_by_months
  end

  def fill_gaps(from_array, to_array)
    from_date = Date.parse(from_array[0])
    to_date = Date.parse(to_array[0])
    days_count = (to_date - from_date).to_i
    average_day_consumption = ( to_array[1] - from_array[1] ) / days_count
    (1...days_count).each do |days|
      new_date = from_date + days
      new_value = from_array[1] + days * average_day_consumption
      date = new_date.strftime("%Y-%m-%d")
      data[date] = new_value
    end
  end

  def fill_before_period
    first_two_data_items = data.sort[0..1]
    first_day_with_value = Date.parse(first_two_data_items[0][0]).strftime("%d").to_i
    return if first_day_with_value == 1
    first_date_with_value = Date.parse(first_two_data_items[0][0])
    day_consumption = first_two_data_items[1][1] - first_two_data_items[0][1]
    current_consumption = first_two_data_items[0][1]
    (1...first_day_with_value).each do |day|
      current_consumption -= day_consumption
      date = (first_date_with_value - day).strftime("%Y-%m-%d")
      data[date] = current_consumption
    end
  end

  def fill_after_period
    last_two_data_items = data.sort[-2,2]
    last_date_with_value = Date.parse(last_two_data_items[1][0])
    first_day_of_next_month = Date.new(last_date_with_value.year, last_date_with_value.month,-1) + 1
    last_day_with_value = Date.parse(last_two_data_items[1][0]).strftime("%d").to_i
    if (1..2).include?(last_day_with_value)
      day_consumption = last_two_data_items[1][1] - last_two_data_items[0][1]
    else
      first_day_of_month_consumption_value = data[Date.new(last_date_with_value.year, last_date_with_value.month, 1).strftime("%Y-%m-%d")]
      days_count = last_day_with_value - 1
      day_consumption = (last_two_data_items[1][1] - first_day_of_month_consumption_value) / days_count
    end
    current_consumption = last_two_data_items[1][1]
    day = 0
    loop do
      day += 1
      current_consumption += day_consumption
      date = (last_date_with_value + day).strftime("%Y-%m-%d")
      data[date] = current_consumption
      break if date == first_day_of_next_month.strftime("%Y-%m-%d")
    end
  end

  def consumption_by_months
    month_consumption = {}
    start_data = data.sort[0]

    month = Date.parse(start_data[0])
    month_value = data[month.strftime("%Y-%m-%d")]
    next_month = month.next_month
    next_month_value = data[next_month.strftime("%Y-%m-%d")]
    loop do

      current_value = sprintf('%.1f', next_month_value - month_value)
      current_month = month.strftime("%Y-%m")
      month_consumption[current_month] = current_value

      month = next_month
      month_value = next_month_value
      next_month = month.next_month
      next_month_value = data[next_month.strftime("%Y-%m-%d")]
      break unless next_month_value
    end
    month_consumption
  end
end
