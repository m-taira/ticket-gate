class Gate
  STATIONS = %i(umeda juso shonai okamachi)
  FARE_TABLE = [
    [false, 150, 180, 220],
    [150, false, 150, 180],
    [180, 150, false, 150],
    [220, 180, 150, false]
  ]

  def initialize(station)
    @station = station
  end

  def entry(ticket)
    raise '入場済みのチケットです。' if ticket.entried?
    ticket.entry(@station)
    ticket
  end

  def come_out(ticket)
    raise '同じ駅では出場できません。' if same_station?(ticket)
    raise '入場していないチケットです。' unless ticket.entried?
    raise '出場済みのチケットです。' if ticket.come_outed?
    ticket.come_out(@station)
    sufficed?(ticket)
  end

  private
  def sufficed?(ticket)
    ticket.amount >= fare(ticket.entry_station, ticket.come_out_station)
  end

  def fare(in_station, out_station)
    in_index = STATIONS.index(in_station)
    out_index = STATIONS.index(out_station)
    FARE_TABLE[in_index][out_index]
  end

  def same_station?(ticket)
    ticket.entry_station == @station
  end
end