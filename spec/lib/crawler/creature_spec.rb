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

    context "with attributes passed in" do
      let(:creature) {
        subject.new({
          name: name,
          hp: hp,
          xp: xp,
          level: level,
        })
      }

      let(:name) { "slab rockhard" }
      let(:hp) { 10 }
      let(:xp) { 20 }
      let(:level) { 3 }

      it "overrides default attributes" do
        expect(creature.name).to eq(name)
        expect(creature.hp).to eq(hp)
        expect(creature.xp).to eq(xp)
        expect(creature.level).to eq(level)
      end
    end
  end

  describe "#level_up" do
    let(:creature) { subject.new({ xp: xp, level: level }) }
    let(:xp) { 0 }
    let(:level) { 0 }

    context "when xp is above level threshold" do
      let(:xp) { 11 }

      it "increases level" do
        creature.level_up
        expect(creature.level).to eq(1)
      end

      it "increases attributes" do
        prev_hp = creature.hp
        creature.level_up
        expect(creature.hp).to be > prev_hp
      end
    end

    context "when xp is not above level threshold" do
      it "does not level up" do
        prev_level = creature.level
        prev_hp = creature.hp
        creature.level_up
        expect(creature.level).to eq(prev_level)
        expect(creature.hp).to eq(prev_hp)
      end

      context "and option 'force' is present" do
        it "levels up" do
          prev_level = creature.level
          prev_hp = creature.hp
          creature.level_up({ force: true })
          expect(creature.level).to be > prev_level
          expect(creature.hp).to be > prev_hp
        end

        context "and old xp is below new level threshold" do
          it "sets xp to new level threshold" do
            prev_xp = creature.xp
            creature.level_up({ force: true })
            expect(creature.xp).to be > prev_xp
          end
        end
      end
    end
  end

  describe "#gain_xp" do
    let(:creature) { subject.new }

    it "adds amount to xp" do
      expect { creature.gain_xp(2) }.to change { creature.xp }.by(2)
    end

    context "when new xp is above next level threshold" do
      it "levels up" do
        expect { creature.gain_xp(11) }.to change  { creature.level }.by(1)
      end
    end

    context "when amount is negative" do
      it "raises an error" do
        expect { creature.gain_xp(-1) }.to raise_error(Crawler::Errors::CreatureError)
      end
    end
  end
end
