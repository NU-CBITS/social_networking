require "spec_helper"

module SocialNetworking
  RSpec.describe "social_networking/profile_pages/show.html.erb", type: :view do
    it "displays all the nudges" do
      allow(view)
        .to receive(:current_participant)
        .and_return(instance_double(Participant, id: 1))
      assign(
        :profile,
        instance_double(
          Profile,
          icon_name: "",
          id: 1,
          participant_id: 1))
      assign(:profile_icons, [])
      assign(:nudging_display_names, [
        "Old Man!", "Red Riding Hood"
      ])

      render

      expect(rendered).to have_text "Old Man! and Red Riding Hood nudged you!"
    end
  end
end
