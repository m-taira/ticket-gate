class FareTable
  STATIONS = %i(umeda juso shonai okamachi)
  FARE_TABLE = [
    [0, 150, 180, 220],
    [150, 0, 150, 180],
    [180, 150, 0, 150],
    [220, 180, 150, 0]
  ]

  def fare(in_station, out_station)
    in_index = station_number(in_station)
    out_index = station_number(out_station)
    FARE_TABLE[in_index][out_index]
  end

  def valid_station?(station)
    STATIONS.include?(station)
  end

  private

  def station_number(station)
    STATIONS.index(station)
  end
end