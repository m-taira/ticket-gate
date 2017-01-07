require 'forwardable'

class Gate
  extend Forwardable

  def_delegator :@fare_table, :valid_station?, :valid_station?

  def initialize(station, fare_table)
    @station = station
    @fare_table = fare_table
    raise '存在しない駅名です。' unless valid_station? station
  end

  def entry(ticket)
    raise '入場済みのチケットです。' if ticket.entried?
    ticket.entry(@station)
    ticket
  end

  def go_out(ticket)
    raise '同じ駅では出場できません。' if same_station?(ticket)
    raise '入場していないチケットです。' unless ticket.entried?
    raise '出場済みのチケットです。' if ticket.go_outed?
    return false if short?(ticket)

    ticket.go_out(@station)
    true
  end

  private

  def short?(ticket)
    ticket.amount < @fare_table.fare(ticket.entry_station, @station)
  end


  def same_station?(ticket)
    ticket.entry_station == @station
  end
end