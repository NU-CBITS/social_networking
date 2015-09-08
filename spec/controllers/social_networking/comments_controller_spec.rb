require "spec_helper"

module SocialNetworking
  describe CommentsController, type: :controller do
    let(:participant) do
      instance_double(
        Participant,
        id: 1,
        is_admin: false)
    end
    let(:comment) do
      instance_double(
        Comment,
        created_at: Time.zone.now,
        id: "foo",
        participant_id: participant.id,
        participant: participant,
        text: "I like cheeses",
        item_id: 5,
        item_type: "SocialNetworking::OnTheMindStatement")
    end

    def recipient(attributes = {})
      instance_double(
        Participant, {
          contact_preference: nil
        }.merge(attributes))
    end

    describe "POST create" do
      describe "when shared item is an 'On Mind Statement'" do
        before do
          @routes = Engine.routes
          allow(Comment).to receive(:new) { comment }
          allow(controller)
            .to receive(:current_participant) { participant }
        end

        context "the record saves" do
          before do
            allow(comment).to receive(:save) { true }
            allow(SocialNetworking::OnTheMindStatement)
              .to receive_message_chain("find.participant_id")
          end

          it "should return the new record" do
            allow(Participant).to receive(:find) { recipient }

            post :create

            assert_response 200
            expect(json["id"]).to eq("foo")
            expect(json["text"]).to eq("I like cheeses")
            expect(json["participantId"]).to eq(participant.id)
          end

          describe "recipient prefers to be contacted via phone" do
            it "should notify via phone" do
              allow(Participant)
                .to receive(:find)
                .and_return(recipient(contact_preference: "phone"))

              expect_any_instance_of(Notification)
                .to receive(:notify)

              post :create
            end
          end

          describe "recipient prefers to be contacted via sms" do
            it "should notify via sms" do
              allow(Participant)
                .to receive(:find)
                .and_return(recipient(contact_preference: "sms"))

              expect_any_instance_of(Notification)
                .to receive(:notify)

              post :create
            end
          end

          describe "recipient prefers to be contacted via email" do
            let(:recipient_with_eamil) do
              recipient(contact_preference: "email")
            end
            let(:notication) { instance_double(Notification) }

            before do
              allow(controller).to receive(:t) { "SunnySide" }
              allow(Participant).to receive(:find) do
                recipient_with_eamil
              end
              allow(notication).to receive(:notify)
              allow(Notification).to receive(:new) { notication }
            end

            it "should notify via email with link and text 'SunnySide'" do
              expect(Notification)
                .to receive(:new)
                .with(
                  current_participant: participant,
                  mailer: Mailer,
                  recipient: recipient_with_eamil,
                  message_body: %r{/social_networking/profile_page},
                  subject: "You received a COMMENT on SunnySide")
              expect(notication).to receive(:notify)

              post :create
            end
          end
        end

        context "the record doesn't save" do
          let(:errors) { double("errors", full_messages: ["baz"]) }

          it "returns an error message" do
            allow(comment)
              .to receive_messages(save: false, errors: errors)

            post :create

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end
  end
end
