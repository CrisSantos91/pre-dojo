require './lib/pre_dojo/match'
require './lib/pre_dojo/player'
require './lib/pre_dojo/weapon'
require './lib/pre_dojo/world_kill'
require 'test/unit'

class TestMatch < Test::Unit::TestCase

  def create_match_two_players
    match = PreDojo::Match.new(1234)
    @player1 = match.player('Player 1')
    @player2 = match.player('Player 2')
    match
  end

  def create_match_three_players
    match = PreDojo::Match.new(1234)
    @player1 = match.player('Player 1')
    @player2 = match.player('Player 2')
    @player3 = match.player('Player 3')
    match
  end

  def summary
    <<~SUMMARY
      Match: 1234
      Player: Player 1 - Kills: 5 - Deaths: 0
      Player: Player 2 - Kills: 4 - Deaths: 4
      Player: Player 3 - Kills: 2 - Deaths: 8
      Winner: Player 1 - Favorite weapon: Bazooka
      Best streak: 5
      Survival Award: Player 1
      5 Kills in 1 minute Award: Player 1
    SUMMARY
  end

  def test_match_winner_two_players
    match = create_match_two_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player2, @player1, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 20))
    assert_equal [@player1], match.winner
  end

  def test_match_tie_two_players
    match = create_match_two_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player2, @player1, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    assert_equal [@player1, @player2], match.winner
  end

  def test_match_winner_two_players_world_kill
    match = create_match_two_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player2, @player1, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.world_kill(@player2, PreDojo::WorldKill::DROWN, Time.new(2017, 5, 10, 10, 0, 20))
    assert_equal [@player1], match.winner
  end

  def test_match_tie_two_players_world_kill
    match = create_match_two_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player2, @player1, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.world_kill(@player1, PreDojo::WorldKill::EARTH_QUAKE, Time.new(2017, 5, 10, 10, 0, 20))
    match.world_kill(@player2, PreDojo::WorldKill::DROWN, Time.new(2017, 5, 10, 10, 0, 25))
    assert_equal [@player1, @player2], match.winner
  end

  def test_match_winner_three_players
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    assert_equal [@player1], match.winner
  end

  def test_match_tie_three_players
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player2, @player1, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    assert_equal [@player1, @player2], match.winner
  end

  def test_favorite_weapons
    match = create_match_two_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player2, @player1, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 20))
    match.world_kill(@player1, PreDojo::WorldKill::EARTH_QUAKE, Time.new(2017, 5, 10, 10, 0, 20))
    match.world_kill(@player2, PreDojo::WorldKill::DROWN, Time.new(2017, 5, 10, 10, 0, 25))
    assert_equal [PreDojo::Weapon::MACHINE_GUN], match.favorite_weapons(@player1)
  end

  def test_two_favorite_weapons
    match = create_match_two_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player2, @player1, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 20))
    match.world_kill(@player1, PreDojo::WorldKill::EARTH_QUAKE, Time.new(2017, 5, 10, 10, 0, 20))
    match.world_kill(@player2, PreDojo::WorldKill::DROWN, Time.new(2017, 5, 10, 10, 0, 25))
    assert_equal [PreDojo::Weapon::M16, PreDojo::Weapon::BAZOOKA], match.favorite_weapons(@player2)
  end

  def test_winner_favorite_weapons
    match = create_match_two_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player2, @player1, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 20))
    match.world_kill(@player1, PreDojo::WorldKill::EARTH_QUAKE, Time.new(2017, 5, 10, 10, 0, 20))
    match.world_kill(@player2, PreDojo::WorldKill::DROWN, Time.new(2017, 5, 10, 10, 0, 25))
    assert_equal [PreDojo::Weapon::MACHINE_GUN], match.favorite_weapons(match.winner[0])
  end

  def test_best_streak_sequence_kills
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 20))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 25))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 30))
    match.player_kill(@player2, @player1, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 35))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 40))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 45))
    match.player_kill(@player3, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 50))
    assert_equal 5, match.best_streak
  end

  def test_best_streak_no_kill
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 20))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 25))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 30))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 35))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 40))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 45))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 50))
    assert_equal 5, match.best_streak
  end

  def test_best_streak_mixed_kills
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player2, @player1, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 20))
    match.player_kill(@player3, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 25))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 30))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 35))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 40))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 45))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 50))
    assert_equal 3, match.best_streak
  end

  def test_best_streak_with_world_kills
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.world_kill(@player1, PreDojo::WorldKill::EARTH_QUAKE, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 20))
    match.world_kill(@player1, PreDojo::WorldKill::EARTH_QUAKE, Time.new(2017, 5, 10, 10, 0, 25))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 30))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 35))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 40))
    match.player_kill(@player2, @player1, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 45))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 50))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 55))
    match.player_kill(@player3, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 1, 0))
    assert_equal 4, match.best_streak
  end  

  def test_survival_award_one_player
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 20))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 25))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 30))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 35))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 40))
    assert_equal [@player1], match.survival_award
  end

  def test_survival_award_two_players
    match = create_match_three_players
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 20))
    assert_equal [@player1, @player2], match.survival_award
  end

  def test_survival_award_one_player_world_kill
    match = create_match_three_players
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 20))
    match.world_kill(@player1, PreDojo::WorldKill::EARTH_QUAKE, Time.new(2017, 5, 10, 10, 0, 25))
    assert_equal [@player2], match.survival_award
  end

  def test_no_survival_award
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player2, @player1, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 20))
    match.player_kill(@player3, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 25))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 30))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 35))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 40))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 45))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 50))
    assert_equal [], match.survival_award
  end

  def test_five_kills_one_minute_award_one_player_single_killer
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 20))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 30))
    assert_equal [@player1], match.five_kills_one_minute_award
  end

  def test_five_kills_one_minute_award_one_player
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player2, @player1, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 20))
    match.player_kill(@player3, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 25))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 30))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 35))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 40))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 45))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 50))
    assert_equal [@player1], match.five_kills_one_minute_award
  end

  def test_five_kills_one_minute_award_two_players
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 5))
    match.player_kill(@player2, @player1, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 20))
    match.player_kill(@player2, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 25))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 30))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 35))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 40))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 45))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 50))
    assert_equal [@player1, @player2], match.five_kills_one_minute_award
  end

  def test_summary
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))


    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))

    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))


    match.world_kill(@player3, PreDojo::WorldKill::EARTH_QUAKE, Time.new(2017, 5, 10, 10, 0, 20))
    
    assert_equal summary, match.summary
  end
end