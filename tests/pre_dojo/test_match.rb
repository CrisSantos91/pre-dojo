require './lib/pre_dojo/match'
require './lib/pre_dojo/player'
require './lib/pre_dojo/weapon'
require './lib/pre_dojo/world_kill'
require 'test/unit'

class TestMatch < Test::Unit::TestCase

  def setup
    @player1 = PreDojo::Player.new('Player 1')
    @player2 = PreDojo::Player.new('Player 2')
    @player3 = PreDojo::Player.new('Player 3')
  end

  def create_match_two_players
    match = PreDojo::Match.new(1234)
    match.add_player(@player1)
    match.add_player(@player2)
    match
  end

  def create_match_three_players
    match = PreDojo::Match.new(1234)
    match.add_player(@player1)
    match.add_player(@player2)
    match.add_player(@player3)
    match
  end

  def summary
    <<~SUMMARY
      Match: 1234
      Player: Player 1 - Kills: 5 - Deaths: 2
      Player: Player 2 - Kills: 4 - Deaths: 2
      Player: Player 3 - Kills: 2 - Deaths: 7
      Winner: Player 1 - Favorite weapon: Bazooka
      Best streak: 3
      Survival Award: Player 1, Player 2
      5 Kills in 1 minute Award: Player 3
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


  def test_summary
    match = create_match_three_players
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 0))
    match.player_kill(@player1, @player3, PreDojo::Weapon::M16, Time.new(2017, 5, 10, 10, 0, 5))


    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player1, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))
    match.player_kill(@player2, @player3, PreDojo::Weapon::MACHINE_GUN, Time.new(2017, 5, 10, 10, 0, 10))

    match.player_kill(@player3, @player2, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))
    match.player_kill(@player3, @player1, PreDojo::Weapon::BAZOOKA, Time.new(2017, 5, 10, 10, 0, 15))


    match.world_kill(@player3, PreDojo::WorldKill::EARTH_QUAKE, Time.new(2017, 5, 10, 10, 0, 20))
    
    assert_equal summary, match.summary

      # Match: 1234
      # Player: Player 1 - Kills: 5 - Died: 2
      # Player: Player 2 - Kills: 4 - Died: 2
      # Player: Player 3 - Kills: 2 - Died: 7
      # Winner: Player 1 - Favorite weapon: Bazooka
      # Best streak: 3
      # Survival Award: Player 1, Player 2
      # 5 Kills in 1 minute Award: Player 1

  end
end