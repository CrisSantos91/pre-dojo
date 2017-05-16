require "./lib/pre_dojo/log.rb"
require "test/unit"

class TestMatch < Test::Unit::TestCase
  
  FILENAME = Dir.pwd + "/data/log.txt"

  def test_read_match
    match = PreDojo::Log.read_match FILENAME
    assert_not_nil match
    assert_equal 11348965, match.id
    assert_equal Time.new(2013, 4, 23, 15, 34, 22), match.start_time
    assert_equal Time.new(2013, 4, 23, 15, 39, 22), match.end_time
    assert_equal 'Roman', match.winner[0].name
    assert_equal PreDojo::Weapon::M16,  match.favorite_weapons(match.winner[0])[0]
    assert_equal 1, match.best_streak    
    assert_equal 'Roman', match.survival_award[0].name
  end

end