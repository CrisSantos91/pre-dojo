require_relative 'score'

module PreDojo
  class Player

    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end
end