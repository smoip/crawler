require 'spec_helper'

RSpec.describe Crawler::Creature do
  subject { described_class }

  let(:creature) { subject.new }

  describe ".new" do
    it "assigns default attributes" do
      expect(creature.name).to eq("Creature")
      expect(creature.max_hp).to eq(1)
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
        prev_max_hp = creature.max_hp
        creature.level_up
        expect(creature.max_hp).to be > prev_max_hp
      end
    end

    context "when xp is not above level threshold" do
      it "does not level up" do
        prev_level = creature.level
        prev_max_hp = creature.max_hp
        creature.level_up
        expect(creature.level).to eq(prev_level)
        expect(creature.max_hp).to eq(prev_max_hp)
      end

      context "and option 'force' is present" do
        it "levels up" do
          prev_level = creature.level
          prev_max_hp = creature.max_hp
          creature.level_up({ force: true })
          expect(creature.level).to be > prev_level
          expect(creature.max_hp).to be > prev_max_hp
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

  describe "#gain_hp" do
    let(:creature) { subject.new(hp: 1, max_hp: max_hp) }
    let(:max_hp) { 3 }

    it "adds the amount to hp" do
      expect { creature.gain_hp(1) }.to change { creature.hp }.by(1)
    end

    context "when change would exceed max_hp" do
      it "sets hp to max_hp" do
        creature.gain_hp(5)
        expect(creature.hp).to eq(max_hp)
      end
    end
  end

  describe "#lose_hp" do
    it "subtracts the amount from hp" do
      expect { creature.lose_hp(1) }.to change { creature.hp }.by(-1)
    end

    context "when change would fall short of 0" do
      it "sets hp to 0" do
        creature.lose_hp(5)
        expect(creature.hp).to eq(0)
      end
    end
  end

  describe "#dead?" do
    context "with postive hp" do
      it "is false" do
        expect(creature.dead?).to be false
      end
    end

    context "with zero hp" do
      let(:creature) { subject.new(hp: 0) }

      it "is true" do
        expect(creature.dead?).to be true
      end
    end
  end

  describe "#attack" do
    let(:target) { subject.new }
    let(:damage) { 1 }

    it "calls 'succeeds?'" do
      expect(creature).to receive(:succeeds?).with(creature.attack_power, target.defense_power) { false }
      creature.attack(target)
    end

    context "when hit succeeds" do
      before do
        allow(creature).to receive(:succeeds?).with(creature.attack_power, target.defense_power) { true }
        allow(creature).to receive(:roll_d).with(creature.attack_power) { damage }
    end

      it "removes hp from target" do
        expect { creature.attack(target) }.to change { target.hp }.by(damage * -1)
      end

      it "adds xp to attacker" do
        expect { creature.attack(target) }.to change { creature.xp }.by(target.hit_value)
      end

      context "when target is defeated" do
        let(:damage) { target.hp + 1 }

        it "adds more xp to attacker" do
          expect { creature.attack(target) }.to change { creature.xp }.by(target.defeat_value)
        end
      end
    end
  end
end
