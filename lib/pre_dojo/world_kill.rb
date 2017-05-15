module PreDojo
  class WorldKill
    include Comparable

    DROWN = 'DROWN'
    FALL = 'FALL'
    EARTH_QUAKE = 'EARTH_QUAKE'

    attr_accessor :killed, :killed_by, :kill_time

    def initialize(killed, killed_by, kill_time = Time.new)
      @killed = killed
      @killed_by = killed_by
      @kill_time = kill_time
    end

    def <=>(other)
      kill_time <=> other.kill_time
    end

  end
end