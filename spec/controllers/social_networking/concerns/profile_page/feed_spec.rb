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

        describe "when 12 feed items exist" do
          before do
            %w(
              NudgeSerializer
              OnTheMindStatementSerializer
              SharedItemSerializer
            ).each do |klass|
              allow("SocialNetworking::Serializers::#{klass}".constantize)
                .to receive(:from_collection)
                .and_return([{ createdAtRaw: "" }] * 4)
            end
          end

          it "returns 10 items on first request" do
            expect(items(0).count)
              .to eq 10
          end

          it "returns the next 2 item(s) on second request" do
            expect(items(1).count)
              .to eq 2
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
