require 'yaml'
require './graph'
class MetroInfopoint
  def initialize(path_to_timing_file:, path_to_lines_file:)
     @timing = YAML.load_file(path_to_timing_file)['timing']
     @gr_time = Graph.new
     @start_set = false
     @timing.each do |el|
       @gr_time.add_road(el["start"].to_s, el["end"].to_s, el["time"])
     end
  end

  def calculate(from_station:, to_station:)
    { price: calculate_price(from_station: from_station, to_station: to_station),
      time: calculate_time(from_station: from_station, to_station: to_station) }
  end

  def calculate_price(from_station:, to_station:)
     set_start(from_station)
     path = @gr_time.find_path(to_station)
     price = 0
     path.each do |station1, station2|
       price += @timing.find { |road| (road['start'].to_s == station1 && road['end'].to_s == station2) || (road['start'].to_s == station2 && road['end'].to_s == station1) }['price']
     end
     price
  end

  def calculate_time(from_station:, to_station:)
     set_start(from_station)
     @gr_time.distance_to(to_station)
  end

  def set_start(from_station)
    return if @start_set
    @gr_time.find_ways(from_station)
    @start_set = true
  end
end
