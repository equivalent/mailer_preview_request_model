#require 'minitest/autorun'
#require 'action_mailer'
#require 'action_controller'
#require 'rails'


#require 'rack/test'

#module ApplicationTests
  #class MailerPreviewsTest < ActiveSupport::TestCase
    #include ActiveSupport::Testing::Isolation
    #include Rack::Test::Methods

    #def setup
      #build_app
      #boot_rails
    #end

    #def teardown
      #teardown_app
    #end

    #test "mailer preview has access to request_model" do
      #mailer 'notifier', <<-RUBY
        #class Notifier < ActionMailer::Base
          #default from: "from@example.com"

          #def foo(user_name)
            #mail to: "\#{user_name}@example.org"
          #end
        #end
      #RUBY

      #text_template 'notifier/foo', <<-RUBY
        #Hello, World!
      #RUBY

      ## default request_model is controller params
      #mailer_preview 'notifier', <<-RUBY
        #class NotifierPreview < ActionMailer::Preview
          #def foo
            #Notifier.foo(request_model.fetch('user_name'))
          #end
        #end
      #RUBY

      #app('development')

      #get "/rails/mailers/notifier/foo?user_name=barcar"
      #assert_equal 200, last_response.status
      #assert_match "barcar@example.org", last_response.body
    #end

    #private
      #def build_app
        #super
        #app_file "config/routes.rb", "Rails.application.routes.draw do; end"
      #end

      #def mailer(name, contents)
        #app_file("app/mailers/#{name}.rb", contents)
      #end

      #def mailer_preview(name, contents)
        #app_file("test/mailers/previews/#{name}_preview.rb", contents)
      #end

      #def html_template(name, contents)
        #app_file("app/views/#{name}.html.erb", contents)
      #end

      #def text_template(name, contents)
        #app_file("app/views/#{name}.text.erb", contents)
      #end
  #end
#end
