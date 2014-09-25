require "spec_helper"

module SocialNetworking
  describe CommentsController, type: :controller do
    let(:participant) { double("participant", id: 987) }
    let(:comment) do
      double("comment",
             id: 8_675_309,
             participant_id: participant.id,
             text: "I like cheeses",
             item_id: 5,
             item_type: "Foo")
    end
    let(:errors) { double("errors", full_messages: ["baz"]) }

    describe "POST create" do
      context "when the participant is authenticated" do
        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }
          allow(Comment).to receive(:new).with(
            participant_id: participant.id,
            text: "I like cheeses",
            item_id: "5",
            item_type: "Foo"
          ) { comment }
        end

        context "and the record saves" do
          before { allow(comment).to receive(:save) { true } }

          it "should return the new record" do
            post :create,
                 text: "I like cheeses",
                 itemId: 5,
                 itemType: "Foo",
                 use_route: :social_networking

            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["text"]).to eq("I like cheeses")
            expect(json["participantId"]).to eq(987)
          end
        end

        context "and the record doesn't save" do
          before do
            allow(comment).to receive_messages(save: false, errors: errors)
          end

          it "should return the error message" do
            post :create,
                 text: "I like cheeses",
                 itemId: 5,
                 itemType: "Foo",
                 use_route: :social_networking

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end
  end
end
