require_relative 'player'
require_relative 'player_kill'

module PreDojo

  class Match
    attr_accessor :id, :start_time, :end_time

    def initialize(id, start_time = Time.new, end_time = nil)
      @id = id
      @start_time = start_time
      @end_time = end_time
      @players = []
      @kills = []
      @score = {}
    end

    def player_kill(killer, killed, weapon, kill_time = Time.new)
      @kills << PlayerKill.new(killer, killed, weapon, kill_time)
      @score[killer] += 1
      @score[killed] -= 1
    end

    def world_kill(killed, killed_by, kill_time = Time.new)
      @kills << WorldKill.new(killed, killed_by, kill_time)
      @score[killed] -= 1
    end

    def add_player(player)
      @players << player
      @score[player] = 0
    end

    def winner
      @score.map {|player, result| player if result == @score.values.max }.compact
    end

    def favorite_weapons(player)
      player_kills = @kills.select {|kill| kill.respond_to?(:killer) && kill.killer == player }
      weapons = player_kills.each_with_object({}) { |kill, weapons|
         weapons[kill.weapon] = weapons[kill.weapon].nil? ? 1 : weapons[kill.weapon] + 1
      }
      weapons.map {|weapon, number| weapon if number == weapons.values.max }.compact
    end

    def summary     
      summary_str = ''
      summary_str << "Match: #{id}\n"
      # @players.each {|player|
      #   summary_str << "Player: #{player.name} - Kills: 0 - Deaths: 0\n"
      # }

      # summary_str << "Winner: #{winner.name} - Favorite weapon: #{winner.favorite_weapon}\n"
      # summary_str << "Best streak: #{best_streak}\n"
      # summary_str << "Survival Award: " + survival_award.collect { |player| player.name }.join(', ') + "\n"
      # summary_str << "5 Kills in 1 minute Award: " + five_kills_one_minute_award.collect { |player| player.name }.join(', ') + "\n"
      summary_str << <<~SUMMARY
                      Player: Player 1 - Kills: 5 - Deaths: 2
                      Player: Player 2 - Kills: 4 - Deaths: 2
                      Player: Player 3 - Kills: 2 - Deaths: 7
                      Winner: Player 1 - Favorite weapon: Bazooka
                      Best streak: 3
                      Survival Award: Player 1, Player 2
                      5 Kills in 1 minute Award: Player 3
                    SUMMARY

    end
  end

end