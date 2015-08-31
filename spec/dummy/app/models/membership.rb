class Membership < ActiveRecord::Base
  include SocialNetworking::Concerns::Membership
end
