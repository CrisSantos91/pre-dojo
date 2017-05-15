module PreDojo
  class PlayerKill

    include Comparable

    attr_accessor :killer, :killed, :weapon, :kill_time

    def initialize(killer, killed, weapon, kill_time = Time.new)
      @killer = killer
      @killed = killed
      @weapon = weapon
      @kill_time = kill_time
    end

    def <=>(other)
      kill_time <=> other.kill_time
    end
  end
end