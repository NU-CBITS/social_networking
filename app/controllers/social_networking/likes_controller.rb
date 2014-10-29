module SocialNetworking
  # Manage Likes.
  class LikesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def create
      @like = Like.new(sanitized_params)

      if @like.save
        recipient = Participant.find(class_from_item_type(@like.item_type).find(@like.item_id).participant_id)
        notify(recipient)
        render json: Serializers::LikeSerializer.new(@like).to_serialized
      else
        render json: { error: model_errors }, status: 400
      end
    end

    private

    def class_from_item_type(item_type_string)
      item_type_string.split('::').inject(Object) do  |mod, class_name|
        mod.const_get(class_name)
      end
    end

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

    def notify(recipient)
      message_body =
        [ "Someone liked your post! Log in (#{root_url}) to see who.",
          "People like what you're doing! Log in (#{root_url}) to see what's happening!" ].sample

      if "email" == recipient.contact_preference
        send_notify_email(recipient, message_body)
      elsif "sms" == recipient.contact_preference &&
        recipient.phone_number &&
        !recipient.phone_number.blank?
        send_notify_sms(recipient, message_body)
      end
    end

    def send_notify_email(recipient, message_body)
      LikeMailer.like_email_alert(
        recipient, current_participant, message_body)
    end

    def send_notify_sms(recipient, message_body)
      client = Twilio::REST::Client.new(
        Rails.application.config.twilio_account_sid,
        Rails.application.config.twilio_auth_token)
      account = client.account
      account.sms.messages.create(
        from:
          "+#{Rails.application.config.twilio_account_telephone_number}",
        to:
          "+#{recipient.phone_number}",
        body:
          message_body
      )
    end
  end
end
