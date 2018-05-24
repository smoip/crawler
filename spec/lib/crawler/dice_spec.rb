require 'spec_helper'

class Tester
  include Crawler::Dice
end

RSpec.describe Crawler::NameHelper do
  let(:tester) { Tester.new }

  describe "#roll_d" do
    it "returns a number within range" do
      expect(tester.roll_d(5)).to be_between(1, 5)
      expect(tester.roll_d(50)).to be_between(1, 50)
    end
  end
end
