require './lib/pre_dojo'
require 'stringio'
require 'test/unit'

class TestPreDojo < Test::Unit::TestCase

  def capture_stdout(&block)
    old = $stdout
    $stdout = fake = StringIO.new
    block.call
    fake.string
  ensure
    $stdout = old
  end

  def summary
    <<~SUMMARY
      Match: 11348965
      Player: Roman - Kills: 1 - Deaths: 0
      Player: Nick - Kills: 0 - Deaths: 2
      Winner: Roman - Favorite weapon: M16
      Best streak: 1
      Survival Award: Roman
      5 Kills in 1 minute Award: 
    SUMMARY
  end

  def test_match_summary
    result = capture_stdout do
      puts PreDojo.match_summary
    end

    assert_equal summary, result
  end

  def test_version
    assert_equal 1, PreDojo::VERSION
  end

end