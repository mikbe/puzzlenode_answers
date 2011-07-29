require 'date'
require './json'

# Default tax rate
TAX_RATE = 1.0411416

# Calculate the rates for the given dates 
# using the provided resort information
# and outputs the results in the specified output_file.
class RateCalculator
  
  # writes the calculated rates for the given information to the specified file
  def self.write_rates(resorts_file, date_file, output_file, tax=TAX_RATE)
    rc = RateCalculator.new
    rc.write_rates(resorts_file, date_file, output_file, tax)
  end

  def write_rates(resorts_file, dates_file, output_file,  tax=TAX_RATE)
    resorts = Resorts.new(resorts_file)
    dates   = Dates.new(dates_file)
    
    File.open(output_file, "w") do |file|
      resorts.each do |resort|
        file.puts calculate_rates(resort, dates.start, dates.end, tax)
      end
    end
  end

  private

  def calculate_rates(resort, start_date, end_date, tax)
    price  = resort.cleaning_fee
    (start_date..(end_date-1)).each do |day| 
      price += resort.rate(day)
    end
    price *= tax
    
    "#{resort["name"]}: #{"$%.2f" % price}"
  end
  
end

# Model for resort data
class Resorts
  
  def initialize(resort_file)
    # load resort data
    @resorts = load_rates(resort_file)
  end

  def each
    (0..@resorts.length-1).each do |index|
      @index = index
      yield self
      @index = nil
    end
  end

  def [](member)
    return unless @index
    @resorts[@index][member]
  end

  def name
    return unless @index
    @resorts[@index]["name"]
  end
  
  def cleaning_fee
    return unless @index
    fee = @resorts[@index]["cleaning fee"]
    fee ? currency_to_float(fee) : 0.0
  end
  
  def rate(day)
    return unless @index
    year = day.year
    seasonal_rates(year).collect do |rate|
      rate[:rate] if day >= rate[:start] && day <= rate[:end]
    end.compact[0]
  end
  
  private
    
  # read a json file and parse it into a Ruby array
  def load_rates(file_name)
    content = IO.readlines(file_name).join
    JSON.parse(content)
  end

  # builds a table of rates for a given year and resort and saves it for later use
  # (premature optimization I couldn't resist because I wanted to learn how)
  def seasonal_rates(year)
    resort = @resorts[@index]
    resort[:rates] ||= []
    resort[:rates][year] ||= 
      if resort["seasons"]
        resort["seasons"].collect do |season_data|
          season      = season_data.values[0]
          start_date  = season["start"]
          end_date    = season["end"]
        
          {  
            start:  Date.parse("#{year}-#{start_date}"), 
            end:    Date.parse("#{end_date > start_date ? year : year + 1}-#{end_date}"), 
            rate:   currency_to_float(season["rate"])
          }
        end
      else
        # no season data so create a regular year
        [{start: Date.parse("#{year}-1-1"), end: Date.parse("#{year}-12-31"), rate: currency_to_float(resort["rate"])}]
      end
    
  end

  def currency_to_float(string_value)
    string_value.delete("$").to_f
  end

end

# Model for time period
class Dates
 
  attr_reader :start, :end
 
  def initialize(date_file)
    date        = File.read(date_file)
    start_end   = date.gsub(" ", "").split("-")
    @start      = Date.parse(start_end[0])
    @end        = Date.parse(start_end[1])
  end
  
end

RateCalculator.write_rates *ARGV

