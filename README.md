# Consumption
Calculates consumption by months

### Usage
Fill in some consumption data to csv file.
The script will calculate consumption for months with provided values (including prediction for the last month and retro values for the first month).
You can find csv example with proper consumption data in gas_consumption.csv file.

Run it:
```
ruby parser.rb gas_consumption.csv
```
You'll receive something like this:
```
{"2022-09"=>"117.7", "2022-10"=>"157.3", "2022-11"=>"225.0"}
```
### Coming soon...

Consumption diagram generation will be added.
