module SocialNetworking
  # Manage Likes.
  class LikesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def create
      @like = Like.new(sanitized_params)

      if @like.save
        set_recipient
        build_notification.notify
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

    def set_recipient
      if "SocialNetworking::SharedItem" == @like.item_type
        like_item_participant_id =
          SharedItem.find(@like.item_id).item_type.constantize
          .find(@like.item_id).participant_id
        @recipient = Participant.find(like_item_participant_id)
      else
        @recipient = Participant
                     .find(@like.item_type.constantize
                     .find(@like.item_id).participant_id)
      end
    end

    def model_errors
      @like.errors.full_messages.join(", ")
    end

    def message_body
      profile_url = social_networking_profile_url

      [
        "Someone liked your post! " \
        "Log in (#{profile_url}) to see who.",
        "People like what you're doing! " \
        "Log in (#{profile_url}) " \
        "to see what's happening!"
      ].sample
    end

    def build_notification
      Notification.new(
        current_participant: current_participant,
        mailer: Mailer,
        recipient: @recipient,
        message_body: message_body,
        subject: "Someone LIKED what you did on "\
        "#{t('application_name', default: 'ThinkFeelDo')}")
    end
  end
end
