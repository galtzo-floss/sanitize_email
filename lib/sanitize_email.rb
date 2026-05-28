# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

# External Libraries
require "version_gem"

# This Library
require_relative "sanitize_email/version"
require_relative "sanitize_email/deprecation"
require_relative "sanitize_email/config"
require_relative "sanitize_email/mail_header_tools"
require_relative "sanitize_email/overridden_addresses"
require_relative "sanitize_email/bleach"

module SanitizeEmail
  FORCE_SANITIZE_MUTEX = Mutex.new

  # Error is raised when a block parameter is required and not provided to a method
  class MissingBlockParameter < StandardError; end

  # Load order matters here!
  # This gem must be loaded **after** Rails in order for the Engine/Railtie to register itself automatically.
  # Otherwise, you'd have to manually require what you need from below.
  # Allow non-rails implementations to use this gem
  # :nocov:
  if defined?(::Rails::VERSION)
    if defined?(::Rails::Engine)
      if ::Rails::VERSION::MAJOR >= 6
        # Rails 6.0+
        require_relative "sanitize_email/engine_v6"
      else
        # Rails 3.1 to 5.2
        require_relative "sanitize_email/engine_v5"
      end
    elsif ::Rails::VERSION::MAJOR == 3 && ::Rails::VERSION::MINOR.zero?
      require_relative "sanitize_email/railtie"
    else
      raise "Please use the 0.X.X versions of sanitize_email for Rails 2.X and below."
    end
  elsif defined?(ActionMailer)
    ActionMailer::Base.register_interceptor(SanitizeEmail::Bleach)
  else
    if defined?(Mailer)
      mailer = Mailer
    elsif defined?(Mail)
      mailer = Mail
    end
    if mailer.respond_to?(:register_interceptor)
      mailer.register_interceptor(SanitizeEmail::Bleach)
    else
      warn "SanitizeEmail was unable to detect a compatible Mail class to register an interceptor on."
    end
  end
  # :nocov:

  class << self
    extend SanitizeEmail::Deprecation

    def force_sanitize
      FORCE_SANITIZE_MUTEX.synchronize { @force_sanitize }
    end

    def force_sanitize=(value)
      FORCE_SANITIZE_MUTEX.synchronize { @force_sanitize = value }
    end

    def [](key)
      return unless key.respond_to?(:to_sym)
      SanitizeEmail::Config.config[key.to_sym]
    end

    def method_missing(name, *_args)
      if name
        SanitizeEmail[name]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name ? method_name : super
    end

    # NOTE: Deprecated method
    # We have to actually define because we can't deprecate methods that are hooked up via method_missing
    def sanitized_recipients
      # NOOP - This method is never actually executed, because the deprecations redirects the call to sanitized_to
    end

    # NOTE: Deprecated method
    # We have to actually define because we can't deprecate methods that are hooked up via method_missing
    def local_environments
      SanitizeEmail::Config.config[:local_environments]
    end

    def activate?(message)
      proc = SanitizeEmail::Config.config[:activation_proc]
      proc.call(message) if proc.respond_to?(:call)
    end

    # Regardless of the Config settings of SanitizeEmail you can do a local
    # override to send sanitary email in any environment.
    # You have access to all the same configuration options in the parameter hash
    # as you can set in the actual SanitizeEmail.configure block.
    #
    # SanitizeEmail.sanitary(sanitized_to: "boo@example.com") do
    #   Mail.deliver do
    #     from      "from@example.org"
    #     # Will actually be sent to the override addresses, not this one:
    #     to        "to@example.org"
    #     reply_to  "reply_to@example.org"
    #     subject   "subject"
    #   end
    # end
    #
    def sanitary(config_options = {})
      raise MissingBlockParameter, "SanitizeEmail.sanitary must be called with a block" unless block_given?
      janitor(forcing: true) do
        original = SanitizeEmail::Config.config.dup
        SanitizeEmail::Config.config.merge!(config_options)
        yield
        SanitizeEmail::Config.config = original
      end
    end

    # Regardless of the Config settings of SanitizeEmail you can do a local
    # override to force unsanitary email in any environment.
    #
    # SanitizeEmail.unsanitary do
    #   Mail.deliver do
    #     from      "from@example.org"
    #     to        "to@example.org"
    #     reply_to  "reply_to@example.org"
    #     subject   "subject"
    #   end
    # end
    #
    def unsanitary
      raise MissingBlockParameter, "SanitizeEmail.unsanitary must be called with a block" unless block_given?
      janitor(forcing: false) do
        yield
      end
    end

    def janitor(options)
      raise MissingBlockParameter, "SanitizeEmail.janitor must be called with a block" unless block_given?
      original = SanitizeEmail.force_sanitize
      SanitizeEmail.force_sanitize = options[:forcing]
      yield
      SanitizeEmail.force_sanitize = original
    end

    deprecated_alias :sanitized_recipients, :sanitized_to
    deprecated :local_environments, :activation_proc
  end
  @force_sanitize = nil
end

SanitizeEmail::Version.class_eval do
  extend VersionGem::Basic
end
