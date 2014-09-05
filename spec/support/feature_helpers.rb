module Features
  module AuthenticationHelpers
    unless ActionController::Base.new.respond_to?(:authenticate_participant!)
      ActionController::Base.class_eval do
        define_method(:authenticate_participant!) { true }
      end
    end
  end
end
