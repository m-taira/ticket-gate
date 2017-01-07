class Ticket
  attr_reader :amount, :entry_station, :go_out_station

  def initialize(amount)
    @amount = amount
    @entry_station = nil
    @go_out_station = nil
  end

  def write_entry(station)
    @entry_station = station
  end

  def write_go_out(station)
    @go_out_station = station
  end

  def entried?
    !@entry_station.nil?
  end

  def go_outed?
    !@go_out_station.nil?
  end
end