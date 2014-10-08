module SocialNetworking
  # Manage Participants.
  class ProfilePagesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    before_action :set_current_profile, :set_profile_questions

    def index
    end

    def show
      if params[:id].present?
        @profile = Profile.find(params[:id])
        store_nudge_initiators(@profile.participant_id)
        participant = Participant.find(@profile.participant_id)
        @profile.user_name = participant.email
        @profile.latest_action_at = participant.latest_action_at
        @profile.active_membership_end_date =
           participant.active_membership_end_date
      end

      load_feed_items
    end

    private

    def set_current_profile
      @profile = Profile.find_or_initialize_by(
         participant_id: current_participant.id)
      if @profile.id.nil?
        @profile.active = true
        @profile.save
      end
      store_nudge_initiators(@profile.participant_id)
      @profile.user_name = current_participant.email
      @profile.latest_action_at = current_participant.latest_action_at
      @profile.active_membership_end_date =
         current_participant.active_membership_end_date
    end

    def store_nudge_initiators(participant_id)
      @notifications = Nudge.search(participant_id)
      @nudges = []
      @notifications.each do | notification |
        @nudges.push(notification.initiator)
      end
    end

    def set_profile_questions
      @profile_questions = ProfileQuestion.all
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end

    def load_feed_items
      pid = @profile.participant_id
      @feed_items = (
        Serializers::OnTheMindStatementSerializer.from_collection(
          OnTheMindStatement.where(participant_id: pid).includes(:comments)
        ) +
        Serializers::NudgeSerializer.from_collection(
          Nudge.where(initiator_id: pid).includes(:comments)
        ) +
        Serializers::SharedItemSerializer.from_collection(
          SharedItem.includes(:item, :comments).to_a.select do |s|
            s.item.participant_id == pid
          end
        )
      )
    end
  end
end
