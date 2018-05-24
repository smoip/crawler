module Crawler
  module Dice
    def roll_d(max)
      (1..max).to_a.sample
    end
  end
end
