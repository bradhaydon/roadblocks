require 'spec_helper'

describe Roadblocks do
  describe ".roadblocks" do
    context "when there are roadblocks set" do
      
      subject { Team.roadblocks }

      it "returns a hash of all possible roadblocks" do
        expect(subject.keys).to include(:displayable)
      end
    end
  end

  describe ".roadblocks_for" do
    context "when a roadblock is set" do
      let(:team) { create(:team) }

      it "clears all roadblocks before validation" do
        expect(team).to receive(:clear_roadblocks).and_return({})
        team.valid?
      end

      it "checks roadblocks after record validation" do
        expect(team).to receive(:roadblocks_for_displayable)
        team.valid?
      end
    end
  end

  describe "#force_roadblocks_update!" do
    context "when the record needs to be re-evaluated" do
      let(:team) { create(:team) }
      
      it "validates roadblocks" do
        expect(team).to receive(:validate_roadblocks).with(:displayable)
        team.force_roadblocks_update!
      end
    end
  end

  describe "roadblock_rule" do
    context "when a roadblock is not valid" do
      let(:team) { create(:team, name: "Red Devil") }

      it "calls roadblock_rule after record validation" do
        expect(team).to receive(:roadblock_rule)
        team.valid?
      end

      it "adds a roadblock error message" do
        expect(team).to_not be_displayable
        expect(team.roadblock_errors[:displayable]).to be_present
        expect(team.roadblock_errors[:displayable]).to include(/word red/)
      end
    end
  end

  describe "validate_roadblocks" do
    
  end
end
