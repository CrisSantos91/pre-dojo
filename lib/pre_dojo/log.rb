require_relative 'weapon'
require_relative 'world_kill'

module PreDojo
  class Log
    
# 23/04/2013 15:34:22 - New match 11348965 has started
# 23/04/2013 15:36:04 - Roman killed Nick using M16
# 23/04/2013 15:36:33 - <WORLD> killed Nick by DROWN
# 23/04/2013 15:39:22 - Match 11348965 has ended

    def self.read_match(filename)
      match = nil
      events = open(filename, 'r').readlines
      events.each { |event|
        match = Match.new($7.to_i, Time.new($3.to_i, $2.to_i, $1.to_i, $4.to_i, $5.to_i, $6.to_i)) if event =~ /(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2}) - New match (\d+) has started/
        if event =~ /(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2}) - (.+) killed (.+) using (.+)/
          kill_time = Time.new($3.to_i, $2.to_i, $1.to_i, $4.to_i, $5.to_i, $6.to_i)
          killer = match.player($7)
          killed = match.player($8)
          weapon = PreDojo::Weapon.const_get($9)
          match.player_kill(killer, killed, weapon, kill_time)
        end
        if event =~ /(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2}) - <WORLD> killed (.*) by (.*)/
          kill_time = Time.new($3.to_i, $2.to_i, $1.to_i, $4.to_i, $5.to_i, $6.to_i)
          killed = match.player($7)
          killed_by  = PreDojo::WorldKill.const_get($8)
          match.world_kill(killed, killed_by, kill_time) 
        end
        match.end_time = Time.new($3.to_i, $2.to_i, $1.to_i, $4.to_i, $5.to_i, $6.to_i) if event =~ /(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2}) - Match (\d+) has ended/
      }
      match
    end
  end
end