# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

RSpec.describe SanitizeEmail do
  # Cleanup, so tests don't bleed
  after do
    SanitizeEmail::Config.config = SanitizeEmail::Config::DEFAULTS
    described_class.force_sanitize = nil
    Mail.class_variable_get(:@@delivery_interceptors).pop
  end

  before do
    SanitizeEmail::Deprecation.deprecate_in_silence = true
    sanitize_spec_dryer
  end

  context "with module methods" do
    describe ":[]" do
      it "accesses config" do
        expect(described_class[:environment]).to eq("[test]")
      end

      it "does not raise on non-responsive to :to_sym" do
        expect { described_class[1234] }.not_to raise_error
      end

      it "returns nil on non-responsive to :to_sym" do
        expect(described_class[1234]).to be_nil
      end
    end

    describe ":method_missing" do
      it "accesses config" do
        expect(described_class.environment).to eq("[test]")
      end

      it "does not raise on unknown method" do
        expect { described_class.deep_space }.not_to raise_error
      end

      it "returns nil on unknown method" do
        expect(described_class.deep_space).to be_nil
      end
    end

    context "when janitor called without block" do
      it "raises error" do
        expect { described_class.janitor({}) }.to raise_error(described_class::MissingBlockParameter)
      end
    end

    context "when unsanitary called without block" do
      it "raises error" do
        expect { described_class.unsanitary }.to raise_error(described_class::MissingBlockParameter)
      end
    end

    context "when unsanitary" do
      before do
        configure_sanitize_email
        unsanitary_mail_delivery
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at sanitize_email.org)",
        )
      end

      it "keeps the original to address" do
        expect(@email_message).to have_to("to@example.org")
      end

      it "does not alter the to username" do
        expect(@email_message).not_to have_to_username("to at")
      end

      it "keeps the original cc address" do
        expect(@email_message).to have_cc("cc@example.org")
      end

      it "keeps the original bcc address" do
        expect(@email_message).to have_bcc("bcc@example.org")
      end

      it "keeps the original subject" do
        expect(@email_message).to have_subject("original subject")
      end
    end

    context "when sanitary called without block" do
      it "raises error" do
        expect { described_class.sanitary }.to raise_error(described_class::MissingBlockParameter)
      end
    end

    context "when sanitary" do
      before do
        configure_sanitize_email
        sanitary_mail_delivery
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at sanitize_email.org)",
        )
      end

      it "sanitizes the to address" do
        expect(@email_message).to have_to("to@sanitize_email.org")
      end

      it "sanitizes the cc address" do
        expect(@email_message).to have_cc("cc@sanitize_email.org")
      end

      it "sanitizes the bcc address" do
        expect(@email_message).to have_bcc("bcc@sanitize_email.org")
      end

      it "sets the original to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end

      it "sets the original cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc",
          "cc@example.org",
        )
      end

      it "does not set the bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc",
          "bcc@sanitize_email.org",
        )
      end

      it "does not prepend the original address to the sanitized username" do
        expect(@email_message).not_to have_to_username(
          "to at example.org <to@sanitize_email.org>",
        )
      end

      it "does not prepend the original address to the subject by default" do
        expect(@email_message).not_to have_subject(
          "(to at example.org) original subject",
        )
      end
    end

    context "when sanitary with multiple recipients" do
      before do
        configure_sanitize_email
        sanitary_mail_delivery_multiple_recipients
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject("(to at sanitize_email.org)")
      end

      it "sanitizes the to address" do
        expect(@email_message).to have_to("to@sanitize_email.org")
      end

      it "sanitizes the cc address" do
        expect(@email_message).to have_cc("cc@sanitize_email.org")
      end

      it "sanitizes the bcc address" do
        expect(@email_message).to have_bcc("bcc@sanitize_email.org")
      end

      it "sets the first sanitized to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "to1@example.org",
        )
      end

      it "does not set a zero-indexed sanitized to header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-To-0",
          "to1@example.org",
        )
      end

      it "does not set a one-indexed sanitized to header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-To-1",
          "to1@example.org",
        )
      end

      it "sets the second sanitized to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To-2",
          "to2@example.org",
        )
      end

      it "sets the third sanitized to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To-3",
          "to3@example.org",
        )
      end

      it "sets the first sanitized cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc",
          "cc1@example.org",
        )
      end

      it "does not set a zero-indexed sanitized cc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Cc-0",
          "cc1@example.org",
        )
      end

      it "does not set a one-indexed sanitized cc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Cc-1",
          "cc1@example.org",
        )
      end

      it "sets the second sanitized cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc-2",
          "cc2@example.org",
        )
      end

      it "sets the third sanitized cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc-3",
          "cc3@example.org",
        )
      end

      it "does not set the first sanitized bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc",
          "bcc1@sanitize_email.org",
        )
      end

      it "does not set a zero-indexed sanitized bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc-0",
          "bcc1@sanitize_email.org",
        )
      end

      it "does not set a one-indexed sanitized bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc-1",
          "bcc1@sanitize_email.org",
        )
      end

      it "does not set the second sanitized bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc-2",
          "bcc2@sanitize_email.org",
        )
      end

      it "does not set the third sanitized bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc-3",
          "bcc3@sanitize_email.org",
        )
      end

      it "does not prepend the original address to the sanitized username" do
        expect(@email_message).not_to have_to_username(
          "to at example.org <to@sanitize_email.org>",
        )
      end

      it "does not prepend the original address to the subject by default" do
        expect(@email_message).not_to have_subject(
          "(to at example.org) original subject",
        )
      end
    end

    context "when sanitary with funky config" do
      before do
        funky_config
        described_class.force_sanitize = true
        mail_delivery
      end

      it "original to is prepended to subject" do
        regex = /\(to at example.org\).*original subject/
        expect(@email_message).to have_subject(regex)
      end

      it "original to is only prepended once to subject" do
        regex = /\(to at example.org\).*\(to at example.org\).*original subject/
        expect(@email_message).not_to have_subject(regex)
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        regex = /.*\(to at sanitize_email.org\).*/
        expect(@email_message).not_to have_subject(regex)
      end

      it "overrides where original recipients were not nil" do
        expect(@email_message).to have_to("funky@sanitize_email.org")
      end

      it "does not sanitize the cc address when the original is nil" do
        expect(@email_message).not_to have_cc("cc@sanitize_email.org")
      end

      it "does not sanitize the bcc address when the original is nil" do
        expect(@email_message).not_to have_bcc("bcc@sanitize_email.org")
      end

      it "sets the original to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end

      it "sets the original cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc",
          "cc@example.org",
        )
      end

      it "does not set headers of bcc" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc",
          "bcc@sanitize_email.org",
        )
      end

      it "does not set the overridden to header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-To",
          "funky@sanitize_email.org",
        )
      end

      it "does not set the overridden cc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Cc",
          "cc@sanitize_email.org",
        )
      end

      it "does not prepend the original address to the sanitized username" do
        expect(@email_message).not_to have_to_username(
          "to at example.org <to@sanitize_email.org>",
        )
      end

      it "does not prepend the original address to the subject by default" do
        expect(@email_message).not_to have_subject(
          "(to at example.org) original subject",
        )
      end
    end

    context "when sanitary with only bcc, which is overriden to nil" do
      before do
        configure_sanitize_email(
          {
            sanitized_to: "to@sanitize_email.org",
            sanitized_cc: nil,
            sanitized_bcc: nil,
            engage: true,
          },
        )
      end

      it "raises error on no recipients left after sanitization" do
        expect { mail_delivery_bcc_only }.to raise_error(SanitizeEmail::OverriddenAddresses::MissingRecipients)
      end
    end

    context "when sanitary with only bcc" do
      before do
        configure_sanitize_email(
          {
            sanitized_to: "to@sanitize_email.org",
            sanitized_cc: nil,
            sanitized_bcc: "bcc@sanitize_email.org",
            engage: true,
          },
        )
        mail_delivery_bcc_only
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "overrides where original recipients were not nil" do
        expect(@email_message).to have_bcc("bcc@sanitize_email.org")
      end

      it "does not sanitize the to address when the original is nil" do
        skip_for(engine: "ruby", versions: "2.3.8", reason: "Can't match(nil)")
        skip_for(engine: "ruby", versions: "2.4.10", reason: "Can't match(nil)")
        expect(@email_message).to have_to(nil)
      end

      it "does not sanitize the cc address when the original is nil" do
        skip_for(engine: "ruby", versions: "2.3.8", reason: "Can't match(nil)")
        skip_for(engine: "ruby", versions: "2.4.10", reason: "Can't match(nil)")
        expect(@email_message).to have_cc(nil)
      end
    end

    context "when sanitary with funky config and hot mess delivery" do
      before do
        funky_config
        described_class.force_sanitize = true
        mail_delivery_hot_mess
      end

      it "original to is prepended to subject" do
        regex = /\(same at example.org\).*original subject/
        expect(@email_message).to match_subject(regex)
      end

      it "original to is only prepended once to subject" do
        regex = /\(same at example.org\).*\(same at example.org\).*original subject/
        expect(@email_message).not_to match_subject(regex)
      end

      it "has the original from address" do
        expect(@email_message).to have_from("same@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("same@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend overrides" do
        expect(@email_message).not_to have_to_username("same at example.org")
      end

      it "overrides where original recipients were not nil" do
        expect(@email_message).to have_to("same@example.org")
      end

      it "does not sanitize the cc address when the original is nil" do
        expect(@email_message).not_to have_cc("same@example.org")
      end

      it "does not sanitize the bcc address when the original is nil" do
        expect(@email_message).not_to have_bcc("same@example.org")
      end

      it "sets the original to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "same@example.org",
        )
      end

      it "sets the original cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc",
          "same@example.org",
        )
      end

      it "does not set headers of bcc" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc",
          "same@example.org",
        )
      end

      it "does not prepend the original address to the sanitized username" do
        expect(@email_message).not_to have_to_username(
          "same at example.org <same@example.org>",
        )
      end

      it "does not prepend the original address to the subject by default" do
        expect(@email_message).not_to have_subject(
          "(same at example.org) original subject",
        )
      end
    end

    context "with frozen string (literals)" do
      it "prepends strings without exception" do
        configure_sanitize_email(
          environment: "{{serverABC}}",
          use_actual_environment_prepended_to_subject: true,
        )
        expect { sanitary_mail_delivery_frozen_strings }.not_to raise_exception
      end
    end

    context "with activation_proc denial" do
      before do
        mail_delivery
      end

      it "does not raise for the default activation proc" do
        expect { mail_delivery }.not_to raise_exception
      end

      it "keeps the original to address for the default activation proc" do
        expect(@email_message).to have_to("to@example.org")
      end

      it "keeps the original from address for the default activation proc" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "keeps the original reply-to address for the default activation proc" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "does not prepend the configured environment for the default activation proc" do
        expect(@email_message).not_to have_subject("## CHEW-GRUEL ##")
      end

      it "keeps the original subject for the default activation proc" do
        expect(@email_message).to have_subject("original subject")
      end

      it "keeps the original body text for the default activation proc" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not add the original to header for the default activation proc" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end

      it "does not raise when activation proc returns false" do
        configure_sanitize_email(
          activation_proc: proc { false },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        expect { mail_delivery }.not_to raise_exception
      end

      it "keeps the original to address when activation proc returns false" do
        configure_sanitize_email(
          activation_proc: proc { false },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        mail_delivery
        expect(@email_message).to have_to("to@example.org")
      end

      it "keeps the original from address when activation proc returns false" do
        configure_sanitize_email(
          activation_proc: proc { false },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        mail_delivery
        expect(@email_message).to have_from("from@example.org")
      end

      it "keeps the original reply-to address when activation proc returns false" do
        configure_sanitize_email(
          activation_proc: proc { false },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        mail_delivery
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "does not prepend the environment when activation proc returns false" do
        configure_sanitize_email(
          activation_proc: proc { false },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        mail_delivery
        expect(@email_message).not_to have_subject("## CHEW-GRUEL ##")
      end

      it "keeps the original subject when activation proc returns false" do
        configure_sanitize_email(
          activation_proc: proc { false },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        mail_delivery
        expect(@email_message).to have_subject("original subject")
      end

      it "keeps the original body text when activation proc returns false" do
        configure_sanitize_email(
          activation_proc: proc { false },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        mail_delivery
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not add the original to header when activation proc returns false" do
        configure_sanitize_email(
          activation_proc: proc { false },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        mail_delivery
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end
    end

    context "with activation_proc denial and disabled activation_proc provided to sanitize" do
      let(:options) do
        {
          activation_proc: proc { false },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        }
      end

      before do
        sanitary_mail_delivery(options)
      end

      it "does not raise" do
        expect { sanitary_mail_delivery(options) }.not_to raise_exception
      end

      it "keeps the original to address" do
        expect(@email_message).to have_to("to@example.org")
      end

      it "keeps the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "keeps the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "does not prepend the environment" do
        expect(@email_message).not_to have_subject("## CHEW-GRUEL ##")
      end

      it "keeps the original subject" do
        expect(@email_message).to have_subject("original subject")
      end

      it "keeps the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not add the original to header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end
    end

    context "with multiple personalizations" do
      before do
        configure_sanitize_email(
          activation_proc: proc { true },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        mail_delivery_multiple_personalizations unless Rails::VERSION::MAJOR == 3
      end

      it "raises for older Rails 3 mail versions" do
        delivery = expect { mail_delivery_multiple_personalizations }

        if Rails::VERSION::MAJOR == 3
          delivery.to raise_exception(
            SanitizeEmail::OverriddenAddresses::MissingRecipients,
            "Mail version is too old to use personalizations",
          )
        else
          delivery.not_to raise_exception
        end
      end

      unless Rails::VERSION::MAJOR == 3
        it "sanitizes the to address" do
          expect(@email_message).to have_to("to@sanitize_email.org")
        end

        it "sanitizes the cc address" do
          expect(@email_message).to have_cc("cc@sanitize_email.org")
        end

        it "sanitizes the bcc address" do
          expect(@email_message).to have_bcc("bcc@sanitize_email.org")
        end

        it "keeps the original from address" do
          expect(@email_message).to have_from("from@example.org")
        end

        it "prepends the environment to the subject" do
          expect(@email_message).to have_subject("## CHEW-GRUEL ## original subject")
        end

        it "keeps the original reply-to address" do
          expect(@email_message).to have_reply_to("reply_to@example.org")
        end

        it "keeps the original body text" do
          expect(@email_message).to have_body_text("funky fresh")
        end

        it "sets the first original to header" do
          expect(@email_message).to have_header(
            "X-Sanitize-Email-To",
            "to1@example.org",
          )
        end

        it "sets the second original to header" do
          expect(@email_message).to have_header(
            "X-Sanitize-Email-To-2",
            "to2@example.org",
          )
        end

        it "sets the third original to header" do
          expect(@email_message).to have_header(
            "X-Sanitize-Email-To-3",
            "to3@example.org",
          )
        end

        it "sets the first original cc header" do
          expect(@email_message).to have_header(
            "X-Sanitize-Email-Cc",
            "cc1@example.org",
          )
        end

        it "sets the second original cc header" do
          expect(@email_message).to have_header(
            "X-Sanitize-Email-Cc-2",
            "cc2@example.org",
          )
        end

        it "sets the third original cc header" do
          expect(@email_message).to have_header(
            "X-Sanitize-Email-Cc-3",
            "cc3@example.org",
          )
        end
      end
    end

    context "with activation_proc enabling" do
      subject(:with_activation_proc) {
        configure_sanitize_email(
          activation_proc: proc { true },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        )
        mail_delivery
      }

      before do
        with_activation_proc
      end

      it "does not raise" do
        block_is_expected.not_to raise_exception
      end

      it "sanitizes the to address" do
        expect(@email_message).to have_to("to@sanitize_email.org")
      end

      it "sanitizes the cc address" do
        expect(@email_message).to have_cc("cc@sanitize_email.org")
      end

      it "sanitizes the bcc address" do
        expect(@email_message).to have_bcc("bcc@sanitize_email.org")
      end

      it "keeps the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "prepends the environment to the subject" do
        expect(@email_message).to have_subject("## CHEW-GRUEL ## original subject")
      end

      it "keeps the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "keeps the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "adds the original to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end
    end

    context "with activation_proc enabling and enabled activation_proc provided to sanitize" do
      let(:options) do
        {
          activation_proc: proc { true },
          environment: "## CHEW-GRUEL ##",
          use_actual_environment_prepended_to_subject: true,
        }
      end

      before do
        configure_sanitize_email
        sanitary_mail_delivery(options)
      end

      it "does not raise" do
        expect { sanitary_mail_delivery(options) }.not_to raise_exception
      end

      it "sanitizes the to address" do
        expect(@email_message).to have_to("to@sanitize_email.org")
      end

      it "sanitizes the cc address" do
        expect(@email_message).to have_cc("cc@sanitize_email.org")
      end

      it "sanitizes the bcc address" do
        expect(@email_message).to have_bcc("bcc@sanitize_email.org")
      end

      it "keeps the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "prepends the environment to the subject" do
        expect(@email_message).to have_subject("## CHEW-GRUEL ## original subject")
      end

      it "keeps the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "keeps the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "adds the original to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end
    end

    context "with force_sanitize when true" do
      before do
        # Should turn off sanitization using the force_sanitize
        configure_sanitize_email(activation_proc: proc { true })
        described_class.force_sanitize = true
        mail_delivery
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "sanitizes the to address" do
        expect(@email_message).to have_to("to@sanitize_email.org")
      end

      it "sanitizes the cc address" do
        expect(@email_message).to have_cc("cc@sanitize_email.org")
      end

      it "sanitizes the bcc address" do
        expect(@email_message).to have_bcc("bcc@sanitize_email.org")
      end

      it "sets the original to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end

      it "sets the original cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc",
          "cc@example.org",
        )
      end

      it "does not set the bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc",
          "bcc@sanitize_email.org",
        )
      end
    end

    context "with force_sanitize when false" do
      before do
        # Should turn off sanitization using the force_sanitize
        configure_sanitize_email(activation_proc: proc { true })
        described_class.force_sanitize = false
        mail_delivery
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "keeps the original to address" do
        expect(@email_message).to have_to("to@example.org")
      end

      it "keeps the original cc address" do
        expect(@email_message).to have_cc("cc@example.org")
      end

      it "keeps the original bcc address" do
        expect(@email_message).to have_bcc("bcc@example.org")
      end

      it "does not add the original to header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end

      it "does not add the original cc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Cc",
          "cc@example.org",
        )
      end

      it "does not add the original bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc",
          "bcc@example.org",
        )
      end
    end

    context "with force_sanitize when nil and activation proc enables" do
      before do
        # Should ignore force_sanitize setting
        configure_sanitize_email(activation_proc: proc { true })
        described_class.force_sanitize = nil
        mail_delivery
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "sanitizes the to address" do
        expect(@email_message).to have_to("to@sanitize_email.org")
      end

      it "sanitizes the cc address" do
        expect(@email_message).to have_cc("cc@sanitize_email.org")
      end

      it "sanitizes the bcc address" do
        expect(@email_message).to have_bcc("bcc@sanitize_email.org")
      end

      it "sets the original to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end

      it "sets the original cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc",
          "cc@example.org",
        )
      end

      it "does not set the bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc",
          "bcc@sanitize_email.org",
        )
      end
    end

    context "with force_sanitize when nil and activation proc disables" do
      before do
        # Should ignore force_sanitize setting
        configure_sanitize_email(activation_proc: proc { false })
        described_class.force_sanitize = nil
        mail_delivery
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "keeps the original to address" do
        expect(@email_message).to have_to("to@example.org")
      end

      it "keeps the original cc address" do
        expect(@email_message).to have_cc("cc@example.org")
      end

      it "keeps the original bcc address" do
        expect(@email_message).to have_bcc("bcc@example.org")
      end

      it "does not add the original to header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end

      it "does not add the original cc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Cc",
          "cc@example.org",
        )
      end

      it "does not add the original bcc header" do
        expect(@email_message).not_to have_header(
          "X-Sanitize-Email-Bcc",
          "bcc@example.org",
        )
      end
    end
  end

  context "with config options" do
    context "with :use_actual_environment_prepended_to_subject when true" do
      before do
        configure_sanitize_email(
          environment: "{{serverABC}}",
          use_actual_environment_prepended_to_subject: true,
        )
        sanitary_mail_delivery
      end

      it "prepends the environment to the subject" do
        expect(@email_message).to have_subject(
          "{{serverABC}} original subject",
        )
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at sanitize_email.org)",
        )
      end
    end

    context "with :use_actual_environment_prepended_to_subject when false" do
      before do
        configure_sanitize_email(
          environment: "{{serverABC}}",
          use_actual_environment_prepended_to_subject: false,
        )
        sanitary_mail_delivery
      end

      it "does not prepend the environment to the subject" do
        expect(@email_message).not_to have_subject(
          "{{serverABC}} original subject",
        )
      end

      it "keeps the original subject" do
        expect(@email_message.subject).to eq("original subject")
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at sanitize_email.org)",
        )
      end
    end

    context "with :use_actual_email_prepended_to_subject when true and to address is an array" do
      before do
        configure_sanitize_email(use_actual_email_prepended_to_subject: true)
        sanitary_mail_delivery_multiple_recipients
      end

      it "prepends every original to address" do
        expect(@email_message).to have_subject(
          "(to1 at example.org,to2 at example.org,to3 at example.org) original subject",
        )
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at sanitize_email.org)",
        )
      end
    end

    context "with :use_actual_email_prepended_to_subject when true and to address is not an array" do
      before do
        configure_sanitize_email(use_actual_email_prepended_to_subject: true)
        sanitary_mail_delivery
      end

      it "prepends the original to address" do
        expect(@email_message).to have_subject(
          "(to at example.org) original subject",
        )
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at sanitize_email.org)",
        )
      end
    end

    context "with :use_actual_email_prepended_to_subject when false" do
      before do
        configure_sanitize_email(use_actual_email_prepended_to_subject: false)
        sanitary_mail_delivery
      end

      it "does not prepend the original to address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at example.org) original subject",
        )
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at sanitize_email.org)",
        )
      end
    end

    context "with :use_actual_email_as_sanitized_user_name when true" do
      before do
        configure_sanitize_email(
          use_actual_email_as_sanitized_user_name: true,
        )
        sanitary_mail_delivery
      end

      it "adds the original to header" do
        expect(@email_message).to have_sanitized_to_header(
          "to@example.org",
        )
      end

      it "uses the original to address as the sanitized username" do
        expect(@email_message).to have_to_username(
          "to at example.org",
        )
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at sanitize_email.org)",
        )
      end
    end

    context "with :use_actual_email_as_sanitized_user_name when false" do
      before do
        configure_sanitize_email(
          use_actual_email_as_sanitized_user_name: false,
        )
        sanitary_mail_delivery
      end

      it "does not use the original to address as the sanitized username" do
        expect(@email_message).not_to have_to_username(
          "to at example.org <to@sanitize_email.org>",
        )
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the sanitized to username" do
        expect(@email_message).not_to have_to_username(
          "to at sanitize_email.org",
        )
      end

      it "does not prepend the sanitized address to the subject" do
        expect(@email_message).not_to have_subject(
          "(to at sanitize_email.org)",
        )
      end
    end

    context "with :engage when enabled" do
      before do
        configure_sanitize_email(
          engage: true,
          sanitized_to: "marv@example.org",
          use_actual_email_prepended_to_subject: true,
          use_actual_email_as_sanitized_user_name: true,
        )
        mail_delivery
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "prepends the original to username" do
        expect(@email_message).to have_to_username("to at example.org")
      end

      it "prepends the original to address to the subject" do
        expect(@email_message).to have_subject("(to at example.org)")
      end

      it "does not keep the original to address" do
        expect(@email_message).not_to have_to("to@example.org")
      end

      it "uses the configured sanitized to address" do
        expect(@email_message).to have_to("marv@example.org")
      end
    end

    context "with :engage when enabled and good list" do
      before do
        configure_sanitize_email(
          engage: true,
          sanitized_to: "marv@example.org",
          sanitized_cc: "blargh@example.org",
          good_list: ["cc@example.org"],
          use_actual_email_prepended_to_subject: true,
          use_actual_email_as_sanitized_user_name: true,
        )
        mail_delivery
      end

      it "prepends the original to username" do
        expect(@email_message).to have_to_username("to at example.org")
      end

      it "does not keep the original to address" do
        expect(@email_message).not_to have_to("to@example.org")
      end

      it "uses the configured sanitized to address" do
        expect(@email_message).to have_to("marv@example.org")
      end

      it "does not use the sanitized cc address" do
        expect(@email_message).not_to have_cc("blargh@example.org")
      end

      it "keeps the good-listed cc address" do
        expect(@email_message).to have_cc("cc@example.org")
      end

      it "keeps the original bcc username" do
        expect(@email_message).to have_bcc_username("bcc at example.org")
      end

      it "sanitizes the bcc address" do
        expect(@email_message).to have_bcc("bcc@sanitize_email.org")
      end

      it "adds the original to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end

      it "adds the original cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc",
          "cc@example.org",
        )
      end
    end

    context "with :engage when enabled and bad list" do
      before do
        configure_sanitize_email(
          engage: true,
          sanitized_to: "marv@example.org",
          sanitized_cc: "cc@example.org",
          good_list: ["to@example.org"],
          bad_list: ["cc@example.org"],
          use_actual_email_prepended_to_subject: true,
          use_actual_email_as_sanitized_user_name: true,
        )
        mail_delivery
      end

      it "does not prepend the original to username" do
        expect(@email_message).not_to have_to_username("to at example.org")
      end

      it "keeps the original to address" do
        expect(@email_message).to have_to("to@example.org")
      end

      it "does not use the configured sanitized to address" do
        expect(@email_message).not_to have_to("marv@example.org")
      end

      it "does not keep the cc address" do
        expect(@email_message).not_to have_cc("cc@example.org")
      end

      it "does not use the fallback cc address" do
        expect(@email_message).not_to have_cc("blargh@example.org")
      end

      it "keeps the original bcc username" do
        expect(@email_message).to have_bcc_username("bcc at example.org")
      end

      it "sanitizes the bcc address" do
        expect(@email_message).to have_bcc("bcc@sanitize_email.org")
      end

      it "adds the original to header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-To",
          "to@example.org",
        )
      end

      it "adds the original cc header" do
        expect(@email_message).to have_header(
          "X-Sanitize-Email-Cc",
          "cc@example.org",
        )
      end
    end

    context "with :engage when disabled" do
      before do
        configure_sanitize_email(
          engage: false,
          sanitized_to: "marv@example.org",
          use_actual_email_prepended_to_subject: true,
          use_actual_email_as_sanitized_user_name: true,
        )
        mail_delivery
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "does not prepend the original to username" do
        expect(@email_message).not_to have_to_username("to at example.org")
      end

      it "does not prepend the original to address to the subject" do
        expect(@email_message).not_to have_subject("(to at example.org)")
      end

      it "keeps the original to address" do
        expect(@email_message).to have_to("to@example.org")
      end

      it "does not use the configured sanitized to address" do
        expect(@email_message).not_to have_to("marv@example.org")
      end
    end

    context "with deprecated :local_environments when matching" do
      before do
        configure_sanitize_email(local_environments: ["test"])
        mail_delivery
      end

      it "enables the activation proc" do
        expect(described_class[:activation_proc].call).to be(true)
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "sanitizes the to address" do
        expect(@email_message).to match_to("to@sanitize_email.org")
      end

      it "sanitizes the cc address" do
        expect(@email_message).to match_cc("cc@sanitize_email.org")
      end

      it "sanitizes the bcc address" do
        expect(@email_message).to match_bcc("bcc@sanitize_email.org")
      end
    end

    context "with deprecated :local_environments when non-matching" do
      before do
        sanitize_spec_dryer("production")
        configure_sanitize_email(local_environments: ["development"])
        mail_delivery
      end

      it "disables the activation proc" do
        expect(described_class[:activation_proc].call).to be(false)
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "keeps the original to address" do
        expect(@email_message).to have_to("to@example.org")
      end

      it "keeps the original cc address" do
        expect(@email_message).to have_cc("cc@example.org")
      end

      it "keeps the original bcc address" do
        expect(@email_message).to have_bcc("bcc@example.org")
      end
    end

    context "with deprecated :sanitized_recipients" do
      before do
        configure_sanitize_email(
          sanitized_recipients: "barney@sanitize_email.org",
        )
        sanitary_mail_delivery
      end

      it "sets sanitized_recipients" do
        expect(described_class.sanitized_recipients).to eq("barney@sanitize_email.org")
      end

      it "maps sanitized_recipients to sanitized_to" do
        expect(described_class.sanitized_to).to eq(described_class.sanitized_recipients)
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "uses sanitized_recipients as sanitized_to" do
        expect(@email_message).to have_to("barney@sanitize_email.org")
      end
    end

    context "with deprecated :force_sanitize" do
      before do
        configure_sanitize_email(
          activation_proc: proc { true },
          force_sanitize: false,
        )
        mail_delivery
      end

      it "has the original from address" do
        expect(@email_message).to have_from("from@example.org")
      end

      it "has the original reply-to address" do
        expect(@email_message).to have_reply_to("reply_to@example.org")
      end

      it "has the original body text" do
        expect(@email_message).to have_body_text("funky fresh")
      end

      it "keeps the original to address" do
        expect(@email_message).to have_to("to@example.org")
      end
    end
  end
end
