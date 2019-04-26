class Graph
  attr_reader :stations_map, :stations, :previous_unit_value, :target_unit_value 

  def initialize
    @stations_map = {} 
    @stations = []
    @path = []
  end

  def add_one_way_road(start_station, end_station, unit)
    if (!stations_map.has_key?(start_station))
      stations_map[start_station] = {end_station => unit}
    else
      stations_map[start_station][end_station] = unit
    end
    if (!stations.include?(start_station))
      stations << start_station	
    end
  end

  def add_road(start_station, end_station, unit)
    add_one_way_road(start_station, end_station, unit)
    add_one_way_road(end_station, start_station, unit) 
  end

  def find_ways(start_station)
    @target_unit_value={}
    @previous_unit_value={}
    stations.each do |node|
      @target_unit_value[node] = Float::INFINITY 
      @previous_unit_value[node] = -1 
    end

    @target_unit_value[start_station] = 0 
    unvisited_stations = stations.compact 
    while (unvisited_stations.size > 0)
      tops = nil;
      unvisited_stations.each do |min|
        tops = min  if !tops || (@target_unit_value[min] && @target_unit_value[min] < @target_unit_value[tops])
      end

      break if @target_unit_value[tops] == Float::INFINITY

      unvisited_stations = unvisited_stations - [tops]
      stations_map[tops].keys.each do |vertex|
        temp = @target_unit_value[tops] + stations_map[tops][vertex]

        if (temp < @target_unit_value[vertex])
          @target_unit_value[vertex] = temp
          @previous_unit_value[vertex] = tops 
        end
      end
    end
  end

  def find_path(dest)
    unless @previous_unit_value[dest] == -1
      find_path(@previous_unit_value[dest])
    end
    unless @previous_unit_value[dest] == -1
      @path << [@previous_unit_value[dest], dest]
    end
    @path
  end

  def distance_to(dest)
    @target_unit_value[dest] == Float::INFINITY ? "no path" : @target_unit_value[dest]
  end
end
