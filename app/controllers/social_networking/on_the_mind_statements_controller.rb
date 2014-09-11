module SocialNetworking
  # Manage OnTheMindStatements.
  class OnTheMindStatementsController < ApplicationController
    def create
      @on_the_mind_statement = OnTheMindStatement.new(sanitized_params)

      if @on_the_mind_statement.save
        render json: {
          id: @on_the_mind_statement.id,
          participantId: @on_the_mind_statement.participant_id,
          description: @on_the_mind_statement.description
        }
      else
        render json: { error: model_errors }, status: 400
      end
    end

    private

    def sanitized_params
      {
        participant_id: current_participant.id,
        description: params[:description]
      }
    end

    def model_errors
      @on_the_mind_statement.errors.full_messages.join(", ")
    end
  end
end
