module PreDojo
  class Score
    attr_reader :kills, :deaths

    def initialize
      @kills = 0
      @deaths = 0
    end

    def add_kill
      @kills += 1
    end

    def add_death
      @deaths += 1
    end

    def total
      @kills - @deaths
    end
  end
end
