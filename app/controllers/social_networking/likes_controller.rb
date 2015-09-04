# Like controller.
module SocialNetworking
  # Manage Likes.
  class LikesController < ApplicationController
    include Sms
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    # Create a new like and notify the creator of the liked item
    def create
      @like = Like.new(sanitized_params)

      if @like.save
        if "SocialNetworking::SharedItem" == @like.item_type
          like_item_type =
            SharedItem.find(@like.item.id).item_type
          like_item_participant_id =
            like_item_type.constantize
            .find(@like.item.item_id).participant_id
          notify Participant.find(like_item_participant_id)
        else
          notify Participant.find(@like.item_type.constantize
                            .find(@like.item_id).participant_id)
        end
        render json: Serializers::LikeSerializer.new(@like).to_serialized
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
      [:itemId, :itemType].each do |param|
        unless params[param].nil?
          s_params[param.to_s.underscore.to_sym] = params[param]
        end
      end

      s_params
    end

    def model_errors
      @like.errors.full_messages.join(", ")
    end

    # Determine the body of the notification and then send the notification
    # based on the contact preferences.
    def notify(recipient)
      return if current_participant == recipient

      message_body = [
        "Someone liked your post! " \
        "Log in (#{home_url}) to see who.",
        "People like what you're doing! " \
        "Log in (#{home_url}) " \
        "to see what's happening!"
      ].sample

      if recipient.contact_preference == "email"
        send_notify_email(recipient, message_body)
      else
        send_sms(recipient, message_body)
      end
    end

    def send_notify_email(recipient, body)
      Mailer
        .notify(
          recipient: recipient,
          body: body,
          subject: "Someone LIKED what you did on "\
          "#{t('application_name', default: 'ThinkFeelDo')}")
    end
  end
end
