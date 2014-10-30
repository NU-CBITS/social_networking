module SocialNetworking
  # Manage Likes.
  class LikesController < ApplicationController
    include ItemUtilities
    include SMSUtilities
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    # Create a new like and notify the creator of the liked item
    def create
      @like = Like.new(sanitized_params)

      if @like.save
        found_item = class_from_item_type(@like.item_type).find_by(item_id: @like.item_id)
        recipient = Participant.find(found_item.participant_id)
        notify(recipient)
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
      message_body = [
        "Someone liked your post! " \
        "Log in (#{root_url}) to see who.",
        "People like what you're doing!" \
        " Log in (#{root_url}) " \
        "to see what's happening!"
      ].sample

      if "email" == recipient.contact_preference
        send_notify_email(recipient, message_body)
      elsif "sms" == recipient.contact_preference &&
        recipient.phone_number &&
        !recipient.phone_number.blank?
        send_sms(recipient, message_body)
      end
    end

    # Trigger a notification email
    def send_notify_email(recipient, message_body)
      LikeMailer.like_email_alert(
        recipient, current_participant, message_body)
    end
  end
end
