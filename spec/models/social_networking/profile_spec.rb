require "spec_helper"

module SocialNetworking
  describe Profile, type: :model do
    fixtures :all

    describe "#started" do
      it "returns false if the participant hasn't answered any questions" do
        expect(Profile.create(
          participant: participants(:participant1))
        .started?).to eq false
      end

      it "returns true if the participant has answered at least one question" do
        expect(social_networking_profiles(:profile2).started?).to eq true
      end
    end
  end
end
