require "./lib/pre_dojo.rb"
require "test/unit"

class TestPreDojo < Test::Unit::TestCase

  def log
    <<~LOG
      23/04/2013 15:34:22 - New match 11348965 has started
      23/04/2013 15:36:04 - Roman killed Nick using M16
      23/04/2013 15:36:33 - <WORLD> killed Nick by DROWN
      23/04/2013 15:39:22 - Match 11348965 has ended
    LOG
  end

  def test_version
    assert_equal 1, PreDojo::VERSION
  end

end