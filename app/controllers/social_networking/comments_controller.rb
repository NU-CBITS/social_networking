module SocialNetworking
  # Manage Comments.
  class CommentsController < ApplicationController
    include Sms
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def create
      @comment = Comment.new(sanitized_params)

      if @comment.save
        notify Participant.find(@comment.item.participant_id)
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

    # Select message from list, determine contact preference, then
    # trigger the notification based on the preference.
    # rubocop:disable Metrics/AbcSize
    def notify(recipient)
      case recipient.contact_status
        when "email"
          send_notify_email(recipient, message_body)
        when "sms"
          if recipient.phone_number && !recipient.phone_number.blank?
            send_sms(recipient, message_body)
          end
        else
          logger.error "ERROR: contact preference is not set for \
participant with ID: " + recipient.id.to_s
      end
    end
    # rubocop:enable Metrics/AbcSize

    # Trigger nudge notification email
    def send_notify_email(recipient, message_body)
      CommentMailer.comment_email_alert(
        recipient,
        message_body,
        "Someone commented on your activity!")
    end

    def message_body
      ["You've sparked some activity! Log in [#{root_url}] to see \
who commented on your post.",
       "Someone commented on your post! Log in [#{root_url}] to\
 learn more."].sample
    end
  end
end

