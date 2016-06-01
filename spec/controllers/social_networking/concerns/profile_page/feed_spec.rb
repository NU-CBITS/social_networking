# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  module Concerns
    # Spec for profile page feed functionality.
    module ProfilePage
      describe Feed do
        let(:participant) do
          instance_double(::Participant, id: 1)
        end

        def items(page)
          Feed.new(participant_id: participant.id,
                   page: page).page_items
        end

        describe "when feed items exist" do
          before do
            allow(Serializers::NudgeSerializer)
              .to receive(:from_collection)
              .and_return([
                            { createdAtRaw: "" },
                            { createdAtRaw: "" }
                          ])
            allow(Serializers::OnTheMindStatementSerializer)
              .to receive(:from_collection)
              .and_return([
                            { createdAtRaw: "" },
                            { createdAtRaw: "" }
                          ])
            allow(Serializers::SharedItemSerializer)
              .to receive(:from_collection)
              .and_return([
                            { createdAtRaw: "" },
                            { createdAtRaw: "" }
                          ])
          end

          it "returns only 5 items on first request" do
            expect(items(0).count).to eq 5
          end

          it "returns the next item(s) on second request" do
            expect(items(1).count).to eq 1
          end
        end

        describe "when no feed items exist" do
          it "returns empty array" do
            expect(items(0)).to eq []
          end
        end
      end
    end
  end
end
