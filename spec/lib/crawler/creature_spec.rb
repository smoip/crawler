require 'spec_helper'

RSpec.describe Crawler::Creature do
  subject { described_class }

  describe ".new" do
    let(:creature) { subject.new }

    it "assigns default attributes" do
      expect(creature.name).to eq("Creature")
      expect(creature.hp).to eq(1)
      expect(creature.xp).to eq(0)
      expect(creature.level).to eq(0)
    end
  end
end
