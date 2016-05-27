# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  describe Profile, type: :model do
    fixtures :all

    let(:participant) { participants(:participant1) }

    describe "#started" do
      it "returns false if the participant hasn't answered any questions" do
        expect(Profile.create(participant: participant).started?).to eq false
      end

      it "returns true if the participant has answered at least one question" do
        expect(social_networking_profiles(:profile2).started?).to eq true
      end
    end

    describe "#user_name" do
      it "does not replace the display_name of a normal participant" do
        allow(participant).to receive(:is_admin).and_return(false)
        expect(Profile.create(participant: participant).user_name)
          .to eq("display name")
      end

      it "replaces the display_name of a moderator with an app-specific name" do
        allow(participant).to receive(:is_admin).and_return(true)
        expect(Profile.create(participant: participant).user_name)
          .to eq("Social Networking")
      end
    end

    it "is shared after creation" do
      expect do
        Profile.create(participant: participant)
      end.to change { SharedItem.count }.by(1)
    end
  end
end
