require_dependency "social_networking/application_controller"

module SocialNetworking
  # Manage shared items
  class SharedItemController < ApplicationController
    SHARED_ITEM_PAGE_SIZE = 5

    skip_before_action :verify_authenticity_token
    def hide
      shared_item_to_hide = SharedItem.find_by_id(shared_item_params[:id])
      if current_participant.id == shared_item_to_hide.item.participant.id
        if shared_item_to_hide.update_attribute(:is_public, false)
          status = :accepted
        else
          status = :internal_server_error
        end
      else
        status = :unauthorized
      end

      respond_to do |format|
        format.html { render nothing: true, status: status }
        format.js   { render nothing: true, status: status }
        format.json { render nothing: true, status: status }
      end
    end

    def page
      items_by_page = []
      requested_page = shared_item_params[:page]
      start_index =
        requested_page ? requested_page.to_i * SHARED_ITEM_PAGE_SIZE : 0
      feed_items_page =
        aggregate_feed_items(
          Participant.find(shared_item_params[:participant_id]),
          requested_page.to_i
        )

      if feed_items_page.size >= start_index
        feed_items =
          feed_items_page.sort_by { |item| item[:createdAtRaw] }.reverse!
        items_by_page =
          feed_items[start_index..(start_index + SHARED_ITEM_PAGE_SIZE - 1)]
      end

      render json: { feedItems: items_by_page }
    end

    private

    def shared_item_params
      params.permit(:id, :participant_id, :page)
    end

    def group_shared_items(participant, requested_page)
      SocialNetworking::SharedItem
        .joins(participant: [{ memberships: :group }])
        .where(groups: { id: participant.active_group.id })
        .order(created_at: :desc)
        .limit(SHARED_ITEM_PAGE_SIZE * (requested_page + 1))
        .includes(:comments, :likes)
    end

    def aggregate_feed_items(participant, page)
      on_the_minds_for_pariticipant_group(participant, page) +
        nudges_for_participant_group(participant, page) +
        shared_items_for_participant_group(participant, page)
    end

    def on_the_minds_for_pariticipant_group(participant, page)
      Serializers::OnTheMindStatementSerializer
        .from_collection(
          OnTheMindStatement.joins(participant: [{ memberships: :group }])
            .where(groups: { id: participant.active_group.id })
            .order(created_at: :desc)
            .limit(SHARED_ITEM_PAGE_SIZE * (page + 1))
            .includes(:comments, :likes))
    end

    def nudges_for_participant_group(participant, page)
      Serializers::NudgeSerializer
        .from_collection(
          Nudge.joins(initiator: [{ memberships: :group }])
            .where(groups: { id: participant.active_group.id })
            .order(created_at: :desc)
            .limit(SHARED_ITEM_PAGE_SIZE * (page + 1))
            .includes(:comments))
    end

    def shared_items_for_participant_group(participant, requested_page)
      Serializers::SharedItemSerializer
        .from_collection(group_shared_items(participant, requested_page))
    end
  end
end
