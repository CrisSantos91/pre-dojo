require_relative 'pre_dojo/version'
require_relative 'pre_dojo/match'
require_relative 'pre_dojo/log'

module PreDojo

  FILENAME = Dir.pwd + "/data/log.txt"

  def summary
    <<~SUMMARY
      Match: 11348965
      Player: Roman - Kills: 1 - Died: 0
      Player: Nick - Kills: 0 - Died: 2
      Winner: Roman - Favorite weapon: M16
      Best streak: 1
      Survival Award: Roman
      5 Kills in 1 minute Award:
    SUMMARY
  end

  def self.match_summary(filename = FILENAME)
    match = Log.read_match filename
    match.summary
  end

end

if __FILE__ == $0
  puts PreDojo.match_summary("../data/log.txt")
end
