require "spec_helper"

module SocialNetworking
  RSpec.describe "social_networking/profile_pages/_profile_questions.html.erb",
                 type: :view do
    let(:profile_message) do
      "Fill out your profile so other group members can get to know you!"
    end

    before do
      allow(view)
        .to receive(:current_participant)
        .and_return(instance_double(Participant, id: 1))
    end

    describe "participant viewing other profile" do
      it "does not display profile form" do
        assign(
          :profile,
          instance_double(
            Profile,
            icon_name: "",
            id: 1,
            participant_id: 2))
        render

        expect(rendered)
          .to_not have_text profile_message
      end
    end

    describe "participant viewing own profile" do
      before do
        assign(
          :profile,
          instance_double(
            Profile,
            icon_name: "",
            id: 1,
            participant_id: 1))
        assign(:profile_icons, [])
      end

      describe "no nudges exist" do
        before do
          assign(:nudging_display_names, [])
          render
        end

        it "does not display nudge message" do
          expect(rendered).to_not have_text "nudged you!"
        end

        it "displays profile question content" do
          expect(rendered).to have_text profile_message
          expect(rendered).to have_text "Profile"
        end

        it "provides the ability to save" do
          expect(rendered).to have_button("Save")
        end

        it "provides the ability to edit profile" do
          expect(rendered).to have_css("button.edit")
        end
      end

      describe "nudges exist" do
        it "displays nudge message along with each initiator's display name" do
          assign(:nudging_display_names, [
            "Old Man!", "Red Riding Hood"
          ])
          render

          expect(rendered)
            .to have_text "Old Man! and Red Riding Hood nudged you!"
        end
      end
    end
  end
end
