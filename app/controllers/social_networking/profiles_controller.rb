module SocialNetworking
  # Manage Participants.
  class ProfilesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      profiles = Profile.all
      render json: Serializers::ProfileSerializer.from_collection(profiles)
    end

    def show
      puts '$$$$$$$$$$$$'

      #ProfileQuestion.create(order: 1, question_text: 'What are your hobbies?', allowed_responses: 3,  deleted: false)
      #ProfileQuestion.create(order: 2, question_text: 'What is your favorite color?', allowed_responses: 1,  deleted: false)

      profile_result = Profile.where(participant_id: current_participant.id)
      if profile_result.empty?
        profile = Profile.create(participant_id: current_participant.id, active: true)
      else
        profile = profile_result.first!
      end

      render json: Serializers::ProfileSerializer.new(profile).to_serialized
    end

    private

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end
