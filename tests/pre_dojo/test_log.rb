require "./lib/pre_dojo/log.rb"
require "test/unit"

class TestMatch < Test::Unit::TestCase
  
  FILENAME = Dir.pwd + "/data/log.txt"

  def test_read_match
    pend
    match = PreDojo::Log.read_match FILENAME
    assert_not_nil match
    assert_equal 11348965, match.id
    assert_equal Time.new(2013, 4, 23, 15, 34, 22), match.start
    assert_equal Time.new(2013, 4, 23, 15, 39, 22), match.end
    # assert_equal 4, data.size
    # assert_equal "23/04/2013 15:34:22 - New match 11348965 has started\n", data[0]
    # assert_equal "23/04/2013 15:36:04 - Roman killed Nick using M16\n", data[1]
    # assert_equal "23/04/2013 15:36:33 - <WORLD> killed Nick by DROWN\n", data[2]
    # assert_equal "23/04/2013 15:39:22 - Match 11348965 has ended\n", data[3]
  end

end