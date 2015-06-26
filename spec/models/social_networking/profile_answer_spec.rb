require "spec_helper"

module SocialNetworking
  describe ProfileAnswer, type: :model do
    fixtures :all

    let(:old_answer) { social_networking_profile_answers(:profile_answer1) }

    it "validates the uniqueness of a profile question and profile" do
      new_answer = ProfileAnswer.new(old_answer.attributes).tap(&:valid?)

      expect(new_answer.errors[:social_networking_profile_question_id].size)
        .to eq 1
      expect(new_answer.errors[:social_networking_profile_question_id][0])
        .to eq "has already been answered"
    end
  end
end
