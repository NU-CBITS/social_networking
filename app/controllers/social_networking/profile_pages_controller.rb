module SocialNetworking
  # Manage Participants.
  class ProfilePagesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    before_action :set_current_profile,
                  :set_profile_questions,
                  :set_profile_icon_names

    def index
    end

    def show
      if params[:id].present?
        @profile = Profile.find(params[:id])
        store_nudge_initiators(@profile.participant_id)
      end

      load_feed_items
    end

    private

    def set_current_profile
      id = params[:id] || current_participant.id
      @profile = Profile.find_or_create_by(
        participant_id: id, active: true) do |profile|
        SharedItem.create(item: profile, action_type: Profile::Actions.created)
      end
      store_nudge_initiators(@profile.participant_id)
    end

    def store_nudge_initiators(participant_id)
      @notifications = Nudge.search(participant_id)
      @nudges = []
      @notifications.each do | notification |
        @nudges.push(notification.initiator.email)
      end
    end

    def set_profile_questions
      @profile_questions = ProfileQuestion.all
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end

    # rubocop:disable Metrics/AbcSize
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
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/MethodLength
    def set_profile_icon_names
      @profile_icons = %w(
        art
        bike
        bolt
        bookshelf
        die
        fashion
        flower
        genius
        heart
        helicopter
        hourglass
        keyboard
        magnifyingglass
        megaphone2
        microphone
        music
        paintbrush2
        plane
        polaroidcamera
        present
        recycle
        scooter
        shipwheel
        shoeprints
        star
        travelerbag
        ufo
        umbrella
        weather)
    end
    # rubocop:enable Metrics/MethodLength
  end
end
