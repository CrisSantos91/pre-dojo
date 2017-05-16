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
      @score[killer].add_kill
      @score[killed].add_death
    end

    def world_kill(killed, killed_by, kill_time = Time.new)
      @kills << WorldKill.new(killed, killed_by, kill_time)
      @score[killed].add_death
    end

    def player(name)
      player = @players.find {|existing_player| existing_player.name == name }

      if player.nil?
        player = Player.new(name)
        @players << player
        @score[player] = Score.new
      end

      player
    end

    def winner
      @players.group_by{ |player| @score[player].total }.max.last
    end

    def favorite_weapons(player)
      player_kills = @kills.select {|kill| kill.respond_to?(:killer) && kill.killer == player }
      weapons = player_kills.each_with_object({}) { |kill, weapons|
         weapons[kill.weapon] = weapons[kill.weapon].nil? ? 1 : weapons[kill.weapon] + 1
      }

      weapons.map {|weapon, number| weapon if number == weapons.values.max }.compact
    end

    def best_streak
      @players.each_with_object({}) {|player, streaks|
        streaks[player] = 0
        player_streak = 0
        @kills.sort.each {|kill|
          player_streak = 0 if kill.killed == player
          player_streak += 1 if kill.respond_to?(:killer) && kill.killer == player
          streaks[player] = player_streak if player_streak > streaks[player]
        }
      }.values.max
    end

    def survival_award
      @players.reject {|player| 
        @kills.any?{|kill| kill.killed == player}        
      }
    end

    def five_kills_one_minute_award
      @players.select {|player|
        player_kills = @kills.select {|kill| kill.respond_to?(:killer) && kill.killer == player}
        player_kills.any? { |player_kill|
          player_kills.count { |kill| kill >= player_kill && player_kill.kill_time - kill.kill_time <= 60} >= 5
        }
      }
    end

    def summary
      summary_str = ''
      summary_str << "Match: #{id}\n"
      @players.each {|player|
        summary_str << "Player: #{player.name} - Kills: #{@score[player].kills} - Deaths: #{@score[player].deaths}\n"
      }
      winner.each {|winner|
        summary_str << "Winner: #{winner.name} - Favorite weapon: #{favorite_weapons(winner).join(', ')}\n"
      }
      summary_str << "Best streak: #{best_streak}\n"
      summary_str << "Survival Award: " + survival_award.collect { |player| player.name }.join(', ') + "\n"
      summary_str << "5 Kills in 1 minute Award: " + five_kills_one_minute_award.collect { |player| player.name }.join(', ') + "\n"
    end
  end

end