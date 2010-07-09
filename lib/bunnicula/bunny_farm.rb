module Bunnicula
  class BunnyFarm

    def self.bunnies
      @@bunnies ||= []
    end

    def self.breed(connection_options={})
      bunny = Bunny.new(connection_options)
      bunnies << bunny
      bunny.start
      bunny
    end



    def self.stop
      bunnies.each {|bunny|bunny.stop}
    end
  end
end
