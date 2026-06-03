module SanitizerSpecHelpers
  DEFAULT_TEST_CONFIG = {
    sanitized_cc: "cc@sanitize_email.org",
    sanitized_bcc: "bcc@sanitize_email.org",
    use_actual_email_prepended_to_subject: false,
    use_actual_environment_prepended_to_subject: false,
    use_actual_email_as_sanitized_user_name: false,
  }.freeze

  def sanitize_spec_dryer(rails_env = "test")
    logger = Logger.new($stdout).tap do |logsy|
      logsy.level = 5 # Unknown (make it silent!)
    end

    Mail.defaults do
      if Rails::VERSION::MAJOR == 3
        delivery_method :test
      else
        delivery_method :logger, logger: logger, severity: :info
      end
    end
    SanitizeEmail::Config.instance_variable_set(
      :@config,
      SanitizeEmail::Config::DEFAULTS.dup,
    )
    allow(Rails).to receive(:env).and_return(rails_env)
    SanitizeEmail::Config.config[:environment] = "[#{rails_env}]"
  end

  def configure_sanitize_email(sanitize_hash = {}, register = true)
    options = DEFAULT_TEST_CONFIG.merge(sanitize_hash).dup
    unless sanitize_hash.key?(:sanitized_recipients)
      options.reverse_merge!(sanitized_to: "to@sanitize_email.org")
    end
    configure_from_options(options)
    Mail.register_interceptor(SanitizeEmail::Bleach) if register
  end

  def configure_from_options(options)
    SanitizeEmail::Config.configure do |config|
      config[:engage] = options[:engage]
      config[:environment] = options[:environment]
      config[:activation_proc] = options[:activation_proc]
      config[:sanitized_to] = options[:sanitized_to]
      config[:sanitized_cc] = options[:sanitized_cc]
      config[:sanitized_bcc] = options[:sanitized_bcc]
      config[:use_actual_email_prepended_to_subject] = options[:use_actual_email_prepended_to_subject]
      config[:use_actual_environment_prepended_to_subject] = options[:use_actual_environment_prepended_to_subject]
      config[:use_actual_email_as_sanitized_user_name] = options[:use_actual_email_as_sanitized_user_name]
      config[:good_list] = options[:good_list]
      config[:bad_list] = options[:bad_list]

      # For testing *deprecated* configuration options:
      config[:local_environments] = options[:local_environments] if options[:local_environments]
      config[:sanitized_recipients] = options[:sanitized_recipients] if options[:sanitized_recipients]
      config[:force_sanitize] = options[:force_sanitize] unless options[:force_sanitize].nil?
    end
  end

  def funky_config(register = true)
    SanitizeEmail::Config.configure do |config|
      config[:sanitized_to] =
        %w[
          funky@sanitize_email.org
          yummy@sanitize_email.org
          same@example.org
        ]
      config[:sanitized_cc] = nil
      config[:sanitized_bcc] = nil
      # logic to turn sanitize_email on and off goes in this Proc:
      config[:activation_proc] = proc { Rails.env != "production" }
      config[:use_actual_email_prepended_to_subject] = true
      config[:use_actual_environment_prepended_to_subject] = true
      config[:use_actual_email_as_sanitized_user_name] = false
    end
    Mail.register_interceptor(SanitizeEmail::Bleach) if register
  end

  def sanitary_mail_delivery(config_options = {})
    SanitizeEmail.sanitary(config_options) do
      mail_delivery
    end
  end

  def sanitary_mail_delivery_multiple_recipients(config_options = {})
    SanitizeEmail.sanitary(config_options) do
      mail_delivery_multiple_recipients
    end
  end

  def sanitary_mail_delivery_frozen_strings(config_options = {})
    SanitizeEmail.sanitary(config_options) do
      mail_delivery_frozen_strings
    end
  end

  def unsanitary_mail_delivery
    SanitizeEmail.unsanitary do
      mail_delivery
    end
  end

  def mail_delivery_frozen_strings
    @email_message = Mail.deliver do
      from "from@example.org"
      to "to@example.org"
      subject "original subject" # rubocop:disable RSpec/VariableDefinition, RSpec/VariableName
      body "funky fresh"
    end
  end

  def mail_delivery_bcc_only
    @email_message = Mail.deliver do
      from "from@example.org"
      bcc "bcc@example.org"
      subject "original subject" # rubocop:disable RSpec/VariableDefinition, RSpec/VariableName
      body "funky fresh"
    end
  end

  def mail_delivery_hot_mess
    @email_message = Mail.deliver do
      from "same@example.org"
      to %w[
        same@example.org
        same@example.org
        same@example.org
        same@example.org
        same@example.org
      ]
      cc "same@example.org"
      bcc "same@example.org"
      reply_to "same@example.org"
      subject "original subject" # rubocop:disable RSpec/VariableDefinition, RSpec/VariableName
      body "funky fresh"
    end
  end

  def mail_delivery
    @email_message = Mail.deliver do
      from "from@example.org"
      to "to@example.org"
      cc "cc@example.org"
      bcc "bcc@example.org"
      reply_to "reply_to@example.org"
      subject "original subject" # rubocop:disable RSpec/VariableDefinition, RSpec/VariableName
      body "funky fresh"
    end
  end

  def mail_delivery_multiple_recipients
    @email_message = Mail.deliver do
      from "from@example.org"
      to %w[to1@example.org to2@example.org to3@example.org]
      cc %w[cc1@example.org cc2@example.org cc3@example.org]
      bcc %w[bcc1@example.org bcc2@example.org bcc3@example.org]
      reply_to "reply_to@example.org"
      subject "original subject" # rubocop:disable RSpec/VariableDefinition, RSpec/VariableName
      body "funky fresh"
    end
  end

  def mail_delivery_multiple_personalizations
    @email_message = Mail.new do
      from "from@example.org"
      to %w[to1@example.org to2@example.org to3@example.org]
      cc %w[cc1@example.org cc2@example.org cc3@example.org]
      bcc %w[bcc1@example.org bcc2@example.org bcc3@example.org]
      reply_to "reply_to@example.org"
      subject "original subject" # rubocop:disable RSpec/VariableDefinition, RSpec/VariableName
      body "funky fresh"
    end
    @email_message["personalizations"] = [
      {
        to: [{email: "to1@example.org"}],
        cc: [{email: "cc1@example.org"}],
      },
      {
        to: [{email: "to2@example.org"}],
        bcc: [{email: "bcc2@example.org"}],
      },
      {
        cc: [{email: "cc3@example.org"}],
        bcc: [{email: "bcc3@example.org"}],
      },
    ]
    @email_message.deliver
  end
end
