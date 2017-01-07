class Ticket
  attr_reader :amount, :entry_station, :come_out_station

  def initialize(amount)
    @amount = amount
    @entry_station = nil
    @come_out_station = nil
  end

  def entry(station)
    @entry_station = station
  end

  def come_out(station)
    @come_out_station = station
  end

  def entried?
    !@entry_station.nil?
  end

  def come_outed?
    !@come_out_station.nil?
  end
end