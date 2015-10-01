module SocialNetworking
  # Manage Participants.
  class ProfilePagesController < ApplicationController
    include Concerns::ProfilePage
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    before_action :set_current_profile,
                  :set_profile_questions,
                  :set_profile_icon_names,
                  :set_navigation_status_context
    def index
    end

    def show
      store_nudge_initiators(@profile.participant_id)
      set_member_profiles
    end

    def page
      render json: { feedItems: feed.page_items }
    end

    private

    def feed
      Concerns::ProfilePage::Feed.new(
        participant_id: profile_page_params[:participant_id],
        page: profile_page_params[:page])
    end

    def profile_page_params
      params
        .permit(:id, :participant_id, :page)
    end

    def active_group
      current_participant.active_group
    end

    def set_navigation_status_context
      current_participant.navigation_status.context = nil
    end

    def set_member_profiles
      return unless active_group
      group_participants = active_group.active_participants
      @member_profiles = Serializers::ProfileSerializer.from_collection(
        Profile.where(participant_id: group_participants.pluck(:id)))
    end

    def set_current_profile
      if profile_id
        @profile = Profile.find(profile_id)
      else
        @profile = Profile
                   .find_or_initialize_by(
                     participant_id: current_participant.id)
        @profile.update_attributes(active: true)
      end
    end

    def store_nudge_initiators(participant_id)
      @nudging_display_names =  Nudge
                                .search(participant_id)
                                .map { |nudge| nudge.initiator.display_name }
    end

    def set_profile_questions
      @profile_questions = current_participant
                           .active_group
                           .social_networking_profile_questions
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end

    def profile_id
      profile_page_params[:id]
    end

    def set_profile_icon_names
      @profile_icons = Profile.icon_names
    end
  end
end
