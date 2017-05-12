module PreDojo
  class Log
    
# 23/04/2013 15:34:22 - New match 11348965 has started
# 23/04/2013 15:36:04 - Roman killed Nick using M16
# 23/04/2013 15:36:33 - <WORLD> killed Nick by DROWN
# 23/04/2013 15:39:22 - Match 11348965 has ended

    def self.read_match(filename)
      match = nil
      events = open(filename, 'r').readlines
      events.each {|event|

      }
      events[0] =~ /(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2}) - New match (\d+) has started/
      match = Match.new($7.to_i)
      match.start = Time.new($3.to_i, $2.to_i, $1.to_i, $4.to_i, $5.to_i, $6.to_i)
      events[3] =~ /(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2}) - Match (\d+) has ended/
      match.end = Time.new($3.to_i, $2.to_i, $1.to_i, $4.to_i, $5.to_i, $6.to_i)
      match
    end

  end
end