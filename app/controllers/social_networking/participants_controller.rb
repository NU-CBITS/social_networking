# frozen_string_literal: true
require_dependency "social_networking/application_controller"

module SocialNetworking
  # Manage Participants.
  class ParticipantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      participants = Participant.all

      render json: Serializers::ParticipantSerializer
        .from_collection(participants)
    end

    def show
      participant = Participant.find(params[:id])

      render json: Serializers::ParticipantSerializer.new(participant)
        .to_serialized
    end

    private

    def record_not_found
      render json: { error: "participant not found" }, status: 404
    end
  end
end
