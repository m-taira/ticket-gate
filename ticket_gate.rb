require 'minitest/autorun'
require './ticket'
require './gate'
require './fare_table'

class TestTicketGate < Minitest::Test

  def setup
    @fare_table = FareTable.new
  end

  def test_scenario1
    # シナリオ1（1区間）

    # 150円の切符を購入する。
    ticket = Ticket.new(150)

    # 梅田で入場し、十三で出場する。
    in_station = Gate.new(:umeda, @fare_table)
    out_station = Gate.new(:juso, @fare_table)
    ticket = in_station.entry(ticket)

    # 期待する結果: 出場できる。
    assert_equal true, out_station.go_out(ticket)
  end

  def test_scenario2
    # シナリオ2（2区間・運賃不足）

    # 150円の切符を購入する。
    ticket = Ticket.new(150)

    # 梅田で入場し、庄内で出場する。
    in_station = Gate.new(:umeda, @fare_table)
    out_station = Gate.new(:shonai, @fare_table)
    ticket = in_station.entry(ticket)

    # 期待する結果: 出場できない。
    assert_equal false, out_station.go_out(ticket)
  end

  def test_scenario3
    # シナリオ3（2区間・運賃ちょうど）

    # 180円の切符を購入する。
    ticket = Ticket.new(180)

    # 梅田で入場し、庄内で出場する。
    in_station = Gate.new(:umeda, @fare_table)
    out_station = Gate.new(:shonai, @fare_table)
    ticket = in_station.entry(ticket)

    # 期待する結果: 出場できる。
    assert_equal true, out_station.go_out(ticket)
  end

  def test_scenario4
    # シナリオ4（2区間・運賃過多）

    # 220円の切符を購入する。
    ticket = Ticket.new(220)

    # 梅田で入場し、庄内で出場する。
    in_station = Gate.new(:umeda, @fare_table)
    out_station = Gate.new(:shonai, @fare_table)
    ticket = in_station.entry(ticket)

    # 期待する結果: 出場できる。
    assert_equal true, out_station.go_out(ticket)
  end

  def test_scenario5
    #シナリオ5（3区間・運賃不足）

    # 180円の切符を購入する。
    ticket = Ticket.new(180)

    # 梅田で入場し、岡町で出場する。
    in_station = Gate.new(:umeda, @fare_table)
    out_station = Gate.new(:okamachi, @fare_table)
    ticket = in_station.entry(ticket)

    # 期待する結果: 出場できない。
    assert_equal false, out_station.go_out(ticket)
  end

  def test_scenario6
    # シナリオ6（3区間・運賃ちょうど）

    # 220円の切符を購入する。
    ticket = Ticket.new(220)
    # 梅田で入場し、岡町で出場する。
    in_station = Gate.new(:umeda, @fare_table)
    out_station = Gate.new(:okamachi, @fare_table)
    ticket = in_station.entry(ticket)

    # 期待する結果: 出場できる。
    assert_equal true, out_station.go_out(ticket)
  end

  def test_scenario7
    # シナリオ7（梅田以外の駅から乗車する・運賃不足）

    # 150円の切符を購入する。
    ticket = Ticket.new(150)

    # 十三で入場し、岡町で出場する。
    in_station = Gate.new(:juso, @fare_table)
    out_station = Gate.new(:okamachi, @fare_table)
    ticket = in_station.entry(ticket)

    # 期待する結果: 出場できない。
    assert_equal false, out_station.go_out(ticket)
  end

  def test_scenario8
    # シナリオ8（梅田以外の駅から乗車する・運賃ちょうど）

    # 180円の切符を購入する。
    ticket = Ticket.new(180)

    # 十三で入場し、岡町で出場する。
    in_station = Gate.new(:juso, @fare_table)
    out_station = Gate.new(:okamachi, @fare_table)
    ticket = in_station.entry(ticket)

    # 期待する結果: 出場できる。
    assert_equal true, out_station.go_out(ticket)
  end

  def test_scenario9
    # シナリオ9（岡町方面から梅田方面へ向かう）
    # 梅田方面から岡町方面（下り）だけでなく、岡町方面から梅田方面（上り）に対して上記のようなシナリオが有効であることを確認する。

    # 150円の切符を購入する。
    ticket = Ticket.new(150)

    # 岡町で入場し、庄内で出場する。
    in_station = Gate.new(:okamachi, @fare_table)
    out_station = Gate.new(:shonai, @fare_table)
    ticket = in_station.entry(ticket)

    # 期待する結果: 出場できる。
    assert_equal true, out_station.go_out(ticket)
  end

  def test_scenario10
    # シナリオ10（同じ駅で降りる）

    # 150円の切符を購入する。
    ticket = Ticket.new(150)
    # 梅田で入場し、梅田で出場する。
    in_station = Gate.new(:umeda, @fare_table)
    out_station = Gate.new(:umeda, @fare_table)
    ticket = in_station.entry(ticket)


    # 期待する結果: 出場できない。（出場できない理由がわかるようにすること）
    error = assert_raises do
      out_station.go_out(ticket)
    end
    assert_equal '同じ駅では出場できません。', error.message
  end

  def test_scenario11
    # シナリオ11（一度入場した切符でもう一度入場する）

    # 150円の切符を購入する。
    ticket = Ticket.new(150)

    # 梅田で入場する。
    in_station = Gate.new(:umeda, @fare_table)
    ticket = in_station.entry(ticket)

    # さらに同じ切符で梅田から再入場する。
    # 期待する結果: 入場できない。（入場できない理由がわかるようにすること）
    error = assert_raises do
      in_station.entry(ticket)
    end

    assert_equal '入場済みのチケットです。', error.message
  end

  def test_scenario12
    # シナリオ12（使用済みの切符でもう一度出場する）

    # 150円の切符を購入する。
    ticket = Ticket.new(150)

    # 梅田で入場し、十三で出場する。
    in_station = Gate.new(:umeda, @fare_table)
    out_station = Gate.new(:juso, @fare_table)

    ticket = in_station.entry(ticket)
    out_station.go_out(ticket)

    # さらに同じ切符で十三で再出場する。
    # 期待する結果: 出場できない。（出場できない理由がわかるようにすること）
    error = assert_raises do
      out_station.go_out(ticket)
    end

    assert_equal '出場済みのチケットです。', error.message
  end

  def test_scenario13
    # シナリオ13（改札を通っていない切符で出場する）

    # 150円の切符を購入する。
    ticekt = Ticket.new(150)

    # 入場時に改札機を通さないまま梅田で出場する。
    out_station = Gate.new(:umeda, @fare_table)

    # 期待する結果: 出場できない。（出場できない理由がわかるようにすること）
    error = assert_raises do
      out_station.go_out(ticekt)
    end

    assert_equal '入場していないチケットです。', error.message
  end


  def test_scenario14
    # シナリオ14（自分で新しい仕様を考える）
    # 実際の改札機を想像しながら、プログラムに新しい機能を追加する。

    # 存在しない駅を作る
    error = assert_raises do
      Gate.new(:osaka, @fare_table)
    end
    assert_equal '存在しない駅名です。', error.message
  end

  def test_scenario14_2
    # 乗り過ごしたあと、正しい駅で出場できる
    ticket = Ticket.new(150)

    in_staiton = Gate.new(:umeda, @fare_table)
    out_station_over = Gate.new(:okamachi, @fare_table)
    out_station = Gate.new(:juso, @fare_table)

    ticket = in_staiton.entry(ticket)
    out_station_over.go_out(ticket)

    assert_equal true, out_station.go_out(ticket)
  end
end