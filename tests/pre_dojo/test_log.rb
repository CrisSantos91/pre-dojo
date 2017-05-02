require "./lib/pre_dojo/log.rb"
require "test/unit"

class TestMatch < Test::Unit::TestCase
  
  LOG_FILE = Dir.pwd + "/data/log.txt"

  def test_read_file_not_exist
    assert_raises(Errno::ENOENT) { PreDojo::Log.read "not_exist.txt" }
  end

  def test_read
    data = PreDojo::Log.read LOG_FILE
    assert_false data.empty?
    assert_equal 4, data.size
    assert_equal "23/04/2013 15:34:22 - New match 11348965 has started\n", data[0]
    assert_equal "23/04/2013 15:36:04 - Roman killed Nick using M16\n", data[1]
    assert_equal "23/04/2013 15:36:33 - <WORLD> killed Nick by DROWN\n", data[2]
    assert_equal "23/04/2013 15:39:22 - Match 11348965 has ended\n", data[3]
  end

end