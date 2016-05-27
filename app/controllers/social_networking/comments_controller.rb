# frozen_string_literal: true
require_dependency "social_networking/application_controller"

module SocialNetworking
  # Manage Comments.
  class CommentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def create
      @comment = Comment.new(sanitized_params)

      if @comment.save
        set_recipient
        build_notification.notify
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

    def build_notification
      Notification.new(
        current_participant: current_participant,
        mailer: Mailer,
        recipient: @recipient,
        message_body: message_body,
        subject: "You received a COMMENT on "\
          "#{t('application_name', default: 'ThinkFeelDo')}"
      )
    end

    def set_recipient
      if @comment.item_type == "SocialNetworking::SharedItem"
        comment_item_participant_id =
          SharedItem.find(@comment.item_id).item_type.constantize
                    .find(@comment.item.item_id).participant_id
        @recipient = Participant.find(comment_item_participant_id)
      else
        @recipient = Participant
                     .find(@comment.item_type.constantize
                     .find(@comment.item_id).participant_id)
      end
    end

    def message_body
      profile_url = social_networking_profile_url

      ["You've sparked some activity! Log in [#{profile_url}] to see \
who commented on your post.",
       "Someone commented on your post! Log in [#{profile_url}] to\
 learn more."].sample
    end
  end
end
