require "mailer_preview_request_model/version"

module MailerPreviewRequestModel
  module PreviewWithRequestModel
    def self.prepended(base)
      base.send :attr_accessor, :request_model
    end
  end

  module MailersControllerWithRequestModel
    def preview
      if params[:path] == @preview.preview_name
        @page_title = "Mailer Previews for #{@preview.preview_name}"
        render action: 'mailer'
      else
        email = File.basename(params[:path])

        if @preview.email_exists?(email)
          @email = @preview.call(email, request_model)

          if params[:part]
            part_type = Mime::Type.lookup(params[:part])

            if part = find_part(part_type)
              response.content_type = part_type
              render text: part.respond_to?(:decoded) ? part.decoded : part
            else
              raise AbstractController::ActionNotFound, "Email part '#{part_type}' not found in #{@preview.name}##{email}"
            end
          else
            @part = find_preferred_part(request.format, Mime::HTML, Mime::TEXT)
            render action: 'email', layout: false, formats: %w[html]
          end
        else
          raise AbstractController::ActionNotFound, "Email '#{email}' not found in #{@preview.name}"
        end
      end
    end

    protected

    def request_model
      params
    end
  end
end

ActionMailer::Preview.prepend MailerPreviewRequestModel::PreviewWithRequestModel
Rails::MailersController.prepend MailerPreviewRequestModel::MailersControllerWithRequestModel

# due to original code in Rails beeing not extendable I cannot do
#   ActionMailer::Preview.extend MailerPreviewRequestModel::PreviewWithRequestModel::ClassMethods
# therefore I need to monkey patch the class method
module ActionMailer
  class Preview
    class << self
      def call(email, request_model)
        preview = self.new
        preview.request_model = request_model
        message = preview.public_send(email)
        inform_preview_interceptors(message)
        message
      end
    end
  end
end
