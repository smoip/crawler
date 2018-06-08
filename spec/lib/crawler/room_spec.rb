require 'spec_helper'

RSpec.describe Crawler::Room do
  subject { described_class }

  let(:room) { subject.new }

  describe ".new" do
    it "assigns default attributes" do
      expect(room.name).to eq("Room")
    end

    context "with attributes passed in" do
      let(:room) {
        subject.new({
          name: name,
          outlets: outlets,
          occupants: occupants,
          loot: loot,
          features: features,
        })
      }

      let(:name) { "Cool room" }
      let(:outlets) { [:east] }
      let(:loot) { [:loot] }
      let(:features) { [:features] }
      let(:occupants) { [:occupants] }

      it "assigns attributes" do
        expect(room.name).to eq(name)
        expect(room.outlets).to eq(outlets)
        expect(room.loot).to eq(loot)
        expect(room.features).to eq(features)
        expect(room.occupants).to eq(occupants)
      end
    end

    context "with invalid outlets" do
      let(:outlets) { [:kinda_leftish] }

      it "raises an error" do
        expect { subject.new(outlets: outlets) }.to raise_error(Crawler::Errors::RoomError) 
      end
    end
  end
end
