require "spec_helper"

module SocialNetworking
  describe Shareable do
    context "when intialized without an instance" do
      subject(:shareable) { Shareable.new }

      describe "#action" do
        it "should display's the default action" do
          expect(shareable.action).to eq "Shared"
        end
      end
    end

    context "when intialized with an instance" do
      let(:action_text) { "I have an action" }
      let(:activity) { "ActivityKlass" }
      let(:goal) { double("goal", shared_description: "goal description") }
      subject(:shareable) { Shareable.new(activity) }

      describe "#action" do
        it "should display's an activities status label" do
          allow(activity).to receive(:action) { action_text }

          expect(shareable.action).to eq action_text
        end
      end

      describe "#description" do
        it "should output an item's shared description" do
          expect(Shareable.new(goal).description).to eq("goal description")
        end
        it "should output the default message for a nil item" do
          expect(Shareable.new(nil).description)
            .to eq("Description not available for this item.")
        end
      end
    end
  end
end
