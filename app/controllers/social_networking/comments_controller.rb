module SocialNetworking
  # Manage Comments.
  class CommentsController < ApplicationController
    include Sms
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def create
      @comment = Comment.new(sanitized_params)

      if @comment.save
        if "SocialNetworking::SharedItem" == @comment.item_type
          comment_item_type =
            SharedItem.find(@comment.item.id).item_type
          comment_item_participant_id =
            comment_item_type.constantize
            .find(@comment.item.item_id).participant_id
          notify Participant.find(comment_item_participant_id)
        else
          notify Participant.find(@comment.item_type.constantize
                            .find(@comment.item_id).participant_id)
        end
        render json: Serializers::CommentSerializer.new(@comment).to_serialized
      else
        render json: { error: model_errors }, status: 400
      end
    end

    # Select message from list, determine contact preference, then
    # trigger the notification based on the preference.
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    def notify(recipient)
      return if current_participant == recipient
      if recipient.contact_preference == "email"
        send_notify_email(recipient, message_body)
      else
        send_sms(recipient, message_body)
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity

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

    def send_notify_email(recipient, body)
      Mailer
        .notify(
          recipient: recipient,
          body: body,
          subject: "You received a COMMENT on "\
          "#{t('application_name', default: 'ThinkFeelDo')}")
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
