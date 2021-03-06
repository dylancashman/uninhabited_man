module Devise
  class CustomSessionsController < ::Devise::SessionsController
    before_filter :authenticate

    protected

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['HTTP_USERNAME'] && password == ENV['HTTP_PASSWORD']
      end if Rails.env.production?
    end

  end
end
