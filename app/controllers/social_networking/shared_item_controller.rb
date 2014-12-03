module SocialNetworking
  # Manage shared items
  class SharedItemController < ApplicationController
    skip_before_action :verify_authenticity_token
    def hide
      shared_item_to_hide = SharedItem.find_by_id(shared_item_params[:id])
      if current_participant.id == shared_item_to_hide.item.participant.id
        if shared_item_to_hide.update_attribute(:is_public, false)
          status = :accepted
        else
          status = :internal_server_error
        end
      else
        status = :unauthorized
      end

      respond_to do |format|
        format.html { render nothing: true, status: status }
        format.js   { render nothing: true, status: status }
        format.json { render nothing: true, status: status }
      end
    end

    private

    def shared_item_params
      params.permit(:id)
    end
  end
end
