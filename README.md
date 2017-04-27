# MailerPreviewRequestModel

This gem is a patch that enables Rails to pass Controller `params` to Mailer Previews.
I hope I will convince Rails team to merge [PR 21702](https://github.com/rails/rails/pull/21702) so that 
this gem will not be needed.

references:

* https://github.com/rails/rails/pull/21702
* https://github.com/rails/rails/pull/20646
* https://github.com/rails/rails/pull/20608
* http://stackoverflow.com/questions/29129542/access-request-parameters-in-rails-4-1-mailer-preview

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mailer_preview_request_model'
```

And then execute:

    $ bundle

## Usage

By default you will have access to method `mailer_model`  which is equal
to controller `params`


```ruby
class MyMailerPreview < ActionMailer::Preview
  def good_news
    MyMailer.good_news(client)
  end

  private
     def client
       @client ||= Client.find(request_model.fetch(:client_id))
     end
end
```

`http://0.0.0.0:3000/rails/mailers/my_mailer?client_id=123`

But you can extend it to do more complex stuff (like authentication
objects) ... and teoretically you can have this on some Staging server
to preview email templates and stuff.

```
# config/initializer/mailer_preview.rb

module OverrideRequestModel
  def self.prepended(base)
     base.before_action :authenticate!
  end

  def request_model
     OpenStruct.new(user: current_user, client_id: params[:client_id])
  end

  def current_user
    User.find session[:current_user_id]
  end

  def authenticate!
     raise "not authenticated" unless current_user.admin?
  end
end

Rails::MailersController.prepend OverrideRequestModel
```

```ruby
# app/mailer_previews/my_mailer_preview.rb
class MyMailerPreview < ActionMailer::Preview

  def good_news
    do_some_stuff_with_user_object
    MyMailer.good_news(client)
  end

  private
     def do_some_stuff_with_user_object
        request_model.user.do_some_stuff
     end

     def client
        Client.find(request_model.client_id) 
     end
end
```

`http://0.0.0.0:3000/rails/mailers/my_mailer/good_news?user_id:123&client_id:345`

## Contributing

1. Fork it ( https://github.com/equivalent/mailer_preview_request_model/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Abount the code

The original code of Mailer Preview is composed of long methods with too
much responsibilities. In order to make this patch work I needed to copy
relativly large chunks of original code and extend the original with it
alteration.

### Trobleshooting dev enviroment

* if Nokogiri fails to install make sure you have `zlib1g-dev` installed

## Todo: 

* ApplicationTests::MailerPreviewsTest 

## Alternatives

* https://ruby.unicorn.tv/articles/access-url-request-parameters-from-actionmailer-preview
