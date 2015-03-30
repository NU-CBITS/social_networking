require "spec_helper"

module SocialNetworking
  describe SharedItemController, type: :controller do
    let(:participant) do
      double("participant",
             id: 987,
             active_group: double("group", id: 123)
      )
    end

    before :each do
      @routes = Engine.routes
    end

    describe "POST hide" do
      let(:shared_item) do
        double("shared item", order: "")
      end

      context "when the participant is authenticated" do
        it "should hide a feed item" do
          expect(SharedItem).to receive(:find_by_id) { shared_item }
          expect(controller).to receive(:current_participant) { participant }
          expect(shared_item)
            .to receive_message_chain(:item, :participant, :id) { 987 }
          expect(shared_item).to receive(:update_attribute) { true }

          post :hide,
               id: 123

          expect(response.status).to eq(202)
        end
      end
    end

    describe "GET page" do
      context "when the participant is authenticated" do
        it "should return a json representation of feed items" do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }
          allow(Participant).to receive(:find) { participant }

          on_the_mind_statement_mock = { createdAtRaw: 1 }
          nudge_mock = { createdAtRaw: 2 }
          shared_item_mock = { createdAtRaw: 3 }

          expect(OnTheMindStatement)
            .to receive_message_chain(:joins, :where, :order, :limit, :includes)
          expect(Nudge)
            .to receive_message_chain(:joins, :where, :order, :limit, :includes)
          expect(SharedItem)
            .to receive_message_chain(:joins, :where, :order, :limit, :includes)
          expect(Serializers::OnTheMindStatementSerializer)
            .to receive(:from_collection) { [on_the_mind_statement_mock] }
          expect(Serializers::NudgeSerializer)
            .to receive(:from_collection) { [nudge_mock] }
          expect(Serializers::SharedItemSerializer)
            .to receive(:from_collection) { [shared_item_mock] }

          get :page,
              page: 0,
              participant_id: 987
          expect(response.body).to include("feedItems")
        end
      end
    end
  end
end
