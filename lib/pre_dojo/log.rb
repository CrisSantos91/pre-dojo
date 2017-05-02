module PreDojo
  class Log
    def self.read(filename)
      open(filename, 'r').readlines
    end
  end
end