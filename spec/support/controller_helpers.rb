# frozen_string_literal: true
module Controllers
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end

RSpec.shared_examples "an untrusted action" do
  it "should redirect" do
    expect(response.status)
      .to redirect_to "/"
  end

  it "should redirect to root path" do
    expect(flash[:alert])
      .to eq "Your authenticity token expired. Please try again."
  end
end
