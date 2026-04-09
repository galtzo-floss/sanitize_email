# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

module SanitizeEmail
  # Determines whether to sanitize the headers of an email,
  #   and does so when appropriate.
  class Bleach
    extend SanitizeEmail::Deprecation

    attr_accessor :overridden_addresses # TODO: Just a stub, not implemented

    class << self
      # If all recipient addresses are allow-listed the field is left alone.
      def delivering_email(message)
        return unless sanitize_engaged?(message)

        SanitizeEmail::MailHeaderTools
          .add_original_addresses_as_headers(message)
        SanitizeEmail::MailHeaderTools
          .prepend_custom_subject(message)

        overridden = SanitizeEmail::OverriddenAddresses.new(message)

        message.to = overridden.overridden_to
        message.cc = overridden.overridden_cc
        message.bcc = overridden.overridden_bcc

        return if message["personalizations"].nil?

        message["personalizations"] = nil
        message["personalizations"] = overridden.overridden_personalizations
      end

      # Will be called by the Hook to determine if an override should occur
      # There are three ways SanitizeEmail can be turned on;
      #   in order of precedence they are:
      #
      # 1. SanitizeEmail.force_sanitize = true # by default it is nil
      #   Only useful for local context.
      #   Inside a method where you will be sending an email, set
      #
      #     SanitizeEmail.force_sanitize = true
      #
      #   just prior to delivering it.  Also useful in the console.
      #
      # 2. If SanitizeEmail seems to not be sanitizing,
      #     you have probably not registered the interceptor.
      #   SanitizeEmail tries to do this for you.
      #   *Note*: If you are working in an environment that has
      #           a Mail or Mailer class that uses the register_interceptor API,
      #           the interceptor will already have been registered.
      #   The gem will probably have already done this for you,
      #   but some really old versions of Rails may need you to do this manually:
      #
      #     Mail.register_interceptor(SanitizeEmail::Bleach)
      #
      #   Once registered, SanitizeEmail needs to be engaged:
      #
      #     # in config/initializers/sanitize_email.rb
      #     SanitizeEmail::Config.configure {|config| config[:engage] = true }
      #
      # 3. SanitizeEmail::Config.configure do |config|
      #      config[:activation_proc] = Proc.new { true }
      #    end
      #
      #   If you don't need to compute anything,
      #     then don't use the Proc, go with the previous option.
      #
      # Note: Number 1 is the method used by the SanitizeEmail.sanitary block
      # Note: Number 2 You may need to setup your own register_interceptor
      #
      # If installed but not configured, sanitize_email DOES NOTHING.
      # Until configured the defaults leave it turned off.
      def sanitize_engaged?(message)
        # Don't sanitize the message if it will not be delivered
        return false unless message.perform_deliveries

        # Has it been forced via the force_sanitize mattr?
        forced = SanitizeEmail.force_sanitize
        return forced unless forced.nil?

        # Is this particular instance of Bleach engaged
        engaged = SanitizeEmail::Config.config[:engage]
        return engaged unless engaged.nil?

        # Should we sanitize due to the activation_proc?
        SanitizeEmail.activate?(message)
      end
    end

    def initialize(*args)
      deprecation_message unless args.empty?
    end

    private

    def deprecation_message
      deprecation = <<~DEPRECATION
        SanitizeEmail:
          Passing arguments to SanitizeEmail::Bleach.new is deprecated.
          SanitizeEmail::Bleach.new now takes no arguments.
      DEPRECATION
      self.class.deprecation_warning_message(deprecation)
    end
  end
end
