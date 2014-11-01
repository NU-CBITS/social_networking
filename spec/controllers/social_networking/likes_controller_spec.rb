require "spec_helper"

module SocialNetworking
  describe LikesController, type: :controller do
    let(:participant) { double("participant", id: 987) }
    let(:like) do
      double("like",
             id: 8_675_309,
             participant_id: participant.id,
             item_id: 5,
             item_type: "Comment")
    end
    let(:errors) { double("errors", full_messages: ["baz"]) }

    describe "POST create" do
      context "when the participant is authenticated" do
        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }
          allow(Like).to receive(:new).with(
                           participant_id: participant.id,
                           item_id: "5",
                           item_type: "Comment"
                         ) { like }
        end

        context "and the record saves" do
          before do
            allow(like).to receive(:save) { true }
            allow(controller).to receive(:class_from_item_type) { Comment }
            allow(Comment).to receive(:find_by) {
              double("comment",
                     id: 543_453_45,
                     participant_id: 654_654_654)
            }
            allow(Participant).to receive(:find) {
              double(
                "receiver",
                id: 413_12,
                email: "tester@test.com",
                phone_number: "16309201110",
                contact_preference: "sms"
              )
            }
            allow(controller).to receive(:root_url) { "some.url" }
            allow(controller).to receive(:send_sms) { nil }
          end

          it "should return the new record" do
            post :create,
                 itemId: 5,
                 itemType: "Comment",
                 use_route: :social_networking
            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["participantId"]).to eq(987)
          end
        end

        context "and the record doesn't save" do
          before do
            allow(like).to receive_messages(save: false, errors: errors)
          end

          it "should return the error message" do
            post :create,
                 itemId: 5,
                 itemType: "Comment",
                 use_route: :social_networking

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end
  end
end
