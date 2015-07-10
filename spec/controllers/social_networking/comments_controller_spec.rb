require "spec_helper"

module SocialNetworking
  describe CommentsController, type: :controller do
    let(:participant) do
      double("participant",
             id: 987,
             contact_preference: "sms",
             phone_number: "163009101110",
             is_admin: false)
    end
    let(:participant_email) do
      double("participant",
             id: 987,
             contact_preference: "email",
             phone_number: "163009101110")
    end
    let(:participant_email_2) do
      double("participant_email_2",
             id: 543,
             contact_preference: "email")
    end
    let(:comment) do
      double("comment",
             id: 8_675_309,
             participant_id: participant.id,
             participant: participant,
             text: "I like cheeses",
             item_id: 5,
             item_type: "SocialNetworking::OnTheMindStatement")
    end
    let(:errors) { double("errors", full_messages: ["baz"]) }

    before(:each) { @routes = Engine.routes }

    describe "POST create" do
      context "when the participant is authenticated" do
        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant)
            .and_return(participant_email)
          allow(Comment).to receive(:new).with(
            participant_id: participant.id,
            text: "I like cheeses",
            item_id: "5",
            item_type: "SocialNetworking::OnTheMindStatement"
          ) { comment }
        end

        context "and the record saves" do
          before do
            allow(comment).to receive(:save) { true }
            allow(OnTheMindStatement).to receive(:find) {
              double("item", participant_id: 1)
            }
            allow(Participant).to receive(:find) {
              double("some_participant",
                     id: 987,
                     contact_preference: "sms",
                     phone_number: "16309101110")
            }
            allow(controller).to receive(:notify) { nil }
          end

          it "should return the new record" do
            post :create,
                 text: "I like cheeses",
                 itemId: 5,
                 itemType: "SocialNetworking::OnTheMindStatement"
            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["text"]).to eq("I like cheeses")
            expect(json["participantId"]).to eq(987)
          end
        end

        context "and the record saves" do
          before do
            allow(comment).to receive(:save) { true }
            allow(OnTheMindStatement).to receive(:find) {
                                           double("item", participant_id: 1)
                                         }
            allow(Participant).to receive(:find) { participant_email }
            allow(controller).to receive(:notify) { nil }
          end

          it "should not send out a notification email" do
            post :create,
                 text: "I like cheeses",
                 itemId: 5,
                 itemType: "SocialNetworking::OnTheMindStatement"
            expect(CommentMailer).not_to receive(:comment_email_alert)
            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["text"]).to eq("I like cheeses")
            expect(json["participantId"]).to eq(987)
          end
        end

        context "and the record saves" do
          before do
            allow(comment).to receive(:save) { true }
            allow(OnTheMindStatement)
              .to receive(:find) { double("item", participant_id: 1) }
            allow(Participant).to receive(:find) { participant_email_2 }
          end

          it "should call the comment mailer with a subject" do
            expect(CommentMailer).to receive(:comment_email_alert)
              .with(participant_email_2, /.*[social_networking\/home]/, /.*/)
            post :create,
                 text: "I like cheeses",
                 itemId: 5,
                 itemType: "SocialNetworking::OnTheMindStatement"
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
                 itemType: "SocialNetworking::OnTheMindStatement"

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end

    describe "private methods" do
      describe ".message_body" do
        it "sends the body text with the social networking profile url" do
          expect(controller.send(:message_body))
            .to match %r{/social_networking/profile_page}
        end
      end
    end
  end
end
