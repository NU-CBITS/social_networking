require "spec_helper"

module SocialNetworking
  include ActionDispatch
  describe LikesController, type: :controller do
    let(:participant) { instance_double(Participant, id: 987) }
    let(:participant_email) do
      instance_double(Participant, id: 987, contact_preference: "email")
    end
    let(:participant_test) do
      instance_double(
        Participant,
        display_name: "test",
        is_admin: false)
    end
    let(:like) do
      instance_double(
        Like,
        created_at: Time.zone.now,
        id: 8_675_309,
        participant_id: participant.id,
        item_id: 5,
        item_type: "SocialNetworking::Comment",
        participant: participant_test)
    end
    let(:errors) { double("errors", full_messages: ["baz"]) }

    before(:each) { @routes = Engine.routes }

    describe "POST create" do
      context "when the participant is authenticated" do
        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }
          allow(Like).to receive(:new)
            .with(participant_id: participant.id,
                  item_id: "5",
                  item_type: "SocialNetworking::Comment") { like }
        end

        context "and the record saves" do
          before do
            allow(like).to receive(:save) { true }
            allow(Comment).to receive(:find) {
              instance_double(
                Comment,
                id: 543_453_45,
                participant_id: 654_654_654)
            }
            allow(Participant).to receive(:find) {
              instance_double(
                Participant,
                id: 413_12,
                email: "tester@test.com",
                phone_number: "16309201110",
                contact_preference: "sms"
              )
            }
            allow(controller).to receive(:send_sms) { nil }
          end

          it "should return the new record" do
            post :create,
                 itemId: 5,
                 itemType: "SocialNetworking::Comment"
            allow(LikeMailer).to receive(:like_email_alert) { nil }
            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["participantId"]).to eq(987)
          end
        end

        context "and the record saves" do
          before do
            allow(like).to receive(:save) { true }
            allow(Comment).to receive(:find) do
              instance_double(
                Comment,
                id: 543_453_45,
                participant_id: participant.id)
            end
            allow(Participant).to receive(:find) { participant }
            allow(controller).to receive(:send_sms) { nil }
          end

          it "should not notify of self-likes" do
            post :create,
                 itemId: 5,
                 itemType: "SocialNetworking::Comment"
            expect(LikeMailer).not_to receive(:like_email_alert)
            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["participantId"]).to eq(participant.id)
          end
        end

        context "and the record saves" do
          before do
            allow(like).to receive(:save) { true }
            allow(Comment).to receive(:find) do
              instance_double(
                Comment,
                id: 543_453_45,
                participant_id: participant.id)
            end
            allow(Participant).to receive(:find) { participant_email }
          end

          it "send an email notification with a subject" do
            expect(LikeMailer).to receive(:like_email_alert)
              .with(participant_email, /.*[social_networking\/home]/, /.*/)
            post :create,
                 itemId: 5,
                 itemType: "SocialNetworking::Comment"
            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["participantId"]).to eq(participant.id)
          end
        end

        context "and the record doesn't save" do
          before do
            allow(like).to receive_messages(save: false, errors: errors)
          end

          it "should return the error message" do
            post :create,
                 itemId: 5,
                 itemType: "SocialNetworking::Comment"

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end
  end
end
