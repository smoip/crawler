require 'spec_helper'

RSpec.describe Crawler::NameHelper do
  subject { described_class }

  let(:name) { "Slime" }

  describe ".proper" do
    let(:name) { "dirk gently" }

    it "capitalizes multi-word names" do
      expect(subject.proper(name)).to eq("Dirk Gently")
    end
  end

  describe ".definite" do
    it "prefixes with 'the' and downcases" do
      expect(subject.definite(name)).to eq("the slime")
    end
  end

  describe ".indefinite" do
    it "prefixes with 'a' and downcases" do
      expect(subject.indefinite(name)).to eq("a slime")
    end

    context "when name begins with vowel" do
      let(:name) { "Orange Slime" }

      it "prefixes with 'an'" do
        expect(subject.indefinite(name)).to eq("an orange slime")
      end
    end
  end
end
