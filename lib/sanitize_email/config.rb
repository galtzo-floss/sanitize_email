# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

module SanitizeEmail
  # The API for configuring SanitizeEmail is via `SanitizeEmail.config`
  # Available configuration options are listed in the `DEFAULTS` constant.
  class Config
    extend SanitizeEmail::Deprecation

    CONFIG_MUTEX = Mutex.new

    DEFAULTS = {
      # Specify the BCC addresses for the messages
      #   that go out in "local" environments
      sanitized_bcc: nil,

      # Specify the CC addresses for the messages
      #   that go out in "local" environments
      sanitized_cc: nil,

      # The recipient addresses for the messages,
      #   either as a string (for a single address)
      #   or an array (for multiple addresses)
      #   that go out in "local" environments
      sanitized_to: nil,

      # an allow list
      good_list: nil,

      # a block list
      bad_list: nil,

      environment: if defined?(Rails) && Rails.env.present?
                     "[#{Rails.env}]"
                   else
                     "[UNKNOWN ENVIRONMENT]"
                   end,

      # Use the "real" email address as the username
      #   for the sanitized email address
      # e.g. "real at example.com <sanitized@example.com>"
      use_actual_email_as_sanitized_user_name: false,

      # Prepend the "real" email address onto the Subject line of the message
      # e.g. "real at example.com rest of subject"
      use_actual_email_prepended_to_subject: false,

      # Prepend the Rails environment onto the Subject line of the message
      # e.g. "[development] rest of subject"
      use_actual_environment_prepended_to_subject: false,

      # True / False turns on or off sanitization,
      #   while nil ignores this setting and checks activation_proc
      engage: nil,

      activation_proc: proc { false },
    }.freeze

    INIT_KEYS = [:sanitized_to, :sanitized_cc, :sanitized_bcc, :good_list, :bad_list].freeze
    @config = DEFAULTS.dup

    class << self
      def config
        CONFIG_MUTEX.synchronize { @config }
      end

      def config=(value)
        CONFIG_MUTEX.synchronize { @config = value }
      end

      def configure
        sanitized_recipients = nil

        CONFIG_MUTEX.synchronize do
          yield @config

          # Gracefully handle deprecated config values.
          # Actual deprecation warnings are thrown in the top SanitizeEmail module
          #   thanks to our use of dynamic methods.
          if @config[:local_environments] && defined?(Rails)
            @config[:activation_proc] = proc do
              SanitizeEmail.local_environments.include?(Rails.env)
            end
          end
          if @config[:sanitized_recipients]
            sanitized_recipients = @config[:sanitized_recipients]
            @config[:sanitized_to] = sanitized_recipients
          end
        end

        # calling it to trigger the deprecation warning.
        SanitizeEmail.sanitized_recipients if sanitized_recipients
        config_force_sanitize_deprecation_warning
      end

      def config_force_sanitize_deprecation_warning
        force_sanitize = CONFIG_MUTEX.synchronize { @config[:force_sanitize] }
        return if force_sanitize.nil?

        deprecation_warning_message(
          <<-DEPRECATION,
                SanitizeEmail::Config.config[:force_sanitize] is deprecated.
                Please use SanitizeEmail.force_sanitize or SanitizeEmail.sanitary instead.
                Refer to https://github.com/pboling/sanitize_email/wiki for examples.
        DEPRECATION
        )
        SanitizeEmail.force_sanitize = force_sanitize
      end

      def to_init
        CONFIG_MUTEX.synchronize do
          @config.select { |key, _value| INIT_KEYS.include?(key) }
        end
      end
    end
  end
end
