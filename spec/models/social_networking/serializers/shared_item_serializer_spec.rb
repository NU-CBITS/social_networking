# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  module Serializers
    RSpec.describe SharedItemSerializer do
      let(:participant) { instance_double(Participant, is_admin: true) }

      describe ".to_serialized" do
        context "a valid shared item type" do
          let(:thought) { double("thought", participant_id: 1) }
          let(:shared_item) do
            instance_double(
              SharedItem,
              item: thought,
              item_label: "label",
              id: 1,
              created_at: Time.zone.now,
              is_public: true,
              action_type: "",
              likes: [],
              comments: []
            )
          end
          let(:serialized_shared_item) do
            SharedItemSerializer
              .new(shared_item)
              .to_serialized
          end

          before do
            allow(thought).to receive(:participant) { participant }
            allow(thought).to receive(:to_serialized)
            allow(thought).to receive(:description) { "" }
          end

          it "includes necessary properties" do
            expect(serialized_shared_item)
              .to include(
                :className,
                :id,
                :participantId,
                :isAdmin,
                :createdAt,
                :createdAtRaw,
                :templatePath,
                :isPublic,
                :data,
                :summary,
                :description,
                :comments,
                :likes
              )
          end
        end

        context "an invalid shared item type" do
          let(:engagement) { double("engagement", participant_id: 1) }
          let(:shared_item) do
            instance_double(
              SharedItem,
              item: engagement
            )
          end
          it "ignores unknown shared item model types" do
            expect(shared_item).to receive(:try) { nil }
            expect(SharedItemSerializer.new(shared_item).to_serialized)
              .to be_nil
          end
        end
      end
    end
  end
end
