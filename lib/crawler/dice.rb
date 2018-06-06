module Crawler
  module Dice
    def roll_d(max)
      (1..max).to_a.sample
    end

    def succeeds?(modifier, difficulty)
      (roll_d(Crawler::Config.settings[:base]) + modifier) >= difficulty
    end
  end
end
