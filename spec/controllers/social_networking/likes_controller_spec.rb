require "spec_helper"

module SocialNetworking
  describe LikesController, type: :controller do
    let(:participant) do
      instance_double(
        Participant,
        display_name: "Robin",
        id: 1,
        is_admin: false)
    end
    let(:like) do
      instance_double(
        Like,
        created_at: Time.zone.now,
        id: "foo",
        participant_id: participant.id,
        item_id: 5,
        item_type: "SocialNetworking::Comment",
        participant: participant)
    end

    def recipient(attributes = {})
      instance_double(
        Participant, {
          contact_preference: nil
        }.merge(attributes))
    end

    describe "POST create" do
      describe "when shared item is a 'Comment'" do
        before do
          @routes = Engine.routes
          allow(Like).to receive(:new) { like }
          allow(controller)
            .to receive(:current_participant) { participant }
        end

        context "the record saves" do
          before do
            allow(like).to receive(:save) { true }
            allow(SocialNetworking::Comment)
              .to receive_message_chain("find.participant_id")
          end

          it "should return the new record" do
            allow(Participant)
              .to receive(:find) { recipient }

            post :create

            assert_response 200

            expect(json["id"]).to eq("foo")
            expect(json["participantDisplayName"]).to eq("Robin")
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
              allow(Participant)
                .to receive(:find) { recipient_with_eamil }
              allow(notication).to receive(:notify)
              allow(Notification)
                .to receive(:new) { notication }
            end

            it "should notify via email with link and text 'SunnySide'" do
              expect(Notification)
                .to receive(:new)
                .with(
                  current_participant: participant,
                  mailer: Mailer,
                  recipient: recipient_with_eamil,
                  message_body: %r{/social_networking/profile_page},
                  subject: /SunnySide/)
              expect(notication).to receive(:notify)

              post :create
            end
          end
        end

        context "the record doesn't save" do
          let(:errors) { double("errors", full_messages: ["baz"]) }

          it "returns an error message" do
            allow(like)
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
