module SocialNetworking
  # Manage Comments.
  class CommentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def create
      @comment = Comment.new(sanitized_params)

      if @comment.save
        render json: Serializers::CommentSerializer.new(@comment).to_serialized
      else
        render json: { error: model_errors }, status: 400
      end
    end

    private

    def record_not_found
      render json: { error: "not found" }, status: 404
    end

    def sanitized_params
      s_params = { participant_id: current_participant.id }
      [:itemId, :itemType, :text].each do |param|
        unless params[param].nil?
          s_params[param.to_s.underscore.to_sym] = params[param]
        end
      end

      s_params
    end

    def model_errors
      @comment.errors.full_messages.join(", ")
    end
  end
end
