# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailer_preview_request_model/version'

Gem::Specification.new do |spec|
  spec.name          = "mailer_preview_request_model"
  spec.version       = MailerPreviewRequestModel::VERSION
  spec.authors       = ["Tomas Valent"]
  spec.email         = ["equivalent@eq8.eu"]

  spec.summary       = %q{Enable Rails ActionMailer Preview to accept argumeents}
  spec.description   = %q{gem to patch Rails untill PR 20646 https://github.com/rails/rails/pull/20646 is merged that will enable Mailer Preview to pass params}
  spec.homepage      = "https://github.com/equivalent/mailer_preview_request_model"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", "< 6"
  spec.add_dependency "actionmailer", "< 6"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "< 12.0"
  spec.add_development_dependency "minitest", "~> 5.8"
end
