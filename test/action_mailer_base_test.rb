# encoding: utf-8
require 'minitest/autorun'
require 'action_mailer'
require 'action_controller'
require 'rails'
require 'mailer_preview_request_model'

class BasePreviewInterceptorsTest < ActiveSupport::TestCase
  teardown do
    ActionMailer::Base.preview_interceptors.clear
  end

  class BaseMailer < ActionMailer::Base
    self.mailer_name = "base_mailer"

    def welcome(hash = {})
      headers['X-SPAM'] = "Not SPAM"
      mail({subject: "The first email on new API!"}.merge!(hash))
    end
  end

  class BaseMailerPreview < ActionMailer::Preview
    def welcome
      BaseMailer.welcome
    end
  end

  test "gem should override ActionMailer::Preview.call to 2 method call" do
    request_model = {}
    BaseMailerPreview.call(:welcome, request_model)
  end
end
