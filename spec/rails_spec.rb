require "rails_helper"

RSpec.describe Rails do
  let(:expected_rails_version) { ENV.fetch("RAILS_MAJOR_MINOR", nil) }
  let(:actual_rails_version) { "#{described_class::VERSION::MAJOR}.#{described_class::VERSION::MINOR}" }

  # Expected Rails major.minor comes from RAILS_MAJOR_MINOR for ruby_* appraisals, otherwise from the
  # gemfiles/rails_X_Y.gemfile fragment that the loaded Gemfile actually evals, e.g. the main
  # Gemfile (8.0) vs. the "current" appraisal (7.2).
  let(:bundle_gemfile) { ENV.fetch("BUNDLE_GEMFILE", "") }
  let(:loaded_gemfile) { bundle_gemfile.empty? ? File.expand_path("../Gemfile", __dir__) : bundle_gemfile }
  let(:declared_rails_version) do
    if expected_rails_version && bundle_gemfile.include?("/gemfiles/ruby_")
      expected_rails_version
    else
      File.read(loaded_gemfile).scan(/rails_(\d+)_(\d+)\.gemfile/).last&.join(".")
    end
  end

  before do
    sanitize_spec_dryer
  end

  it "has the Rails Version declared by the loaded gemfile" do
    skip "loaded gemfile declares no Rails version" if declared_rails_version.nil?
    expect(actual_rails_version).to eq(declared_rails_version)
  end

  describe "in App" do
    it "has a mailer configured" do
      expect(HelloMailer < ActionMailer::Base).to be(true)
    end

    context "with mailer" do
      subject(:mail_delivery) { HelloMailer.bonjour.deliver }

      it "does not raise error" do
        block_is_expected.to not_raise_error
      end

      it "has the original from address" do
        expect(mail_delivery).to have_from("roadside-bananas@example.com")
      end

      it "has the original reply-to address" do
        expect(mail_delivery).to have_reply_to("jingle-berry@example.com")
      end

      it "has the original to address" do
        expect(mail_delivery).to have_to("vonnegut@example.com")
      end

      it "has the original cc address" do
        expect(mail_delivery).to have_cc("charlie@example.org")
      end

      it "has the original bcc address" do
        expect(mail_delivery).to have_bcc("candy-mountain@example.org")
      end

      it "has the original body text" do
        expect(mail_delivery).to have_body_text("Hello. Good Day!")
      end

      it "does not sanitize the to username" do
        expect(mail_delivery).not_to have_to_username("vonnegut")
      end

      it "has the original subject" do
        expect(mail_delivery).to have_subject("Your Roadside Bananas")
      end
    end

    context "when sanitary with mailer" do
      subject(:mail_delivery) { HelloMailer.bonjour.deliver }

      before do
        configure_sanitize_email(
          {
            engage: true,
            sanitized_to: "to@sanitize_email.org",
            sanitized_cc: "cc@sanitize_email.org",
            sanitized_bcc: "bcc@sanitize_email.org",
            use_actual_email_prepended_to_subject: true,
            use_actual_environment_prepended_to_subject: true,
            use_actual_email_as_sanitized_user_name: true
          },
          false
        )
      end

      it "does not raise error" do
        block_is_expected.to not_raise_error
      end

      it "has the original from address" do
        expect(mail_delivery).to have_from("roadside-bananas@example.com")
      end

      it "has the original reply-to address" do
        expect(mail_delivery).to have_reply_to("jingle-berry@example.com")
      end

      it "has the sanitized to address" do
        expect(mail_delivery).to have_to("to@sanitize_email.org")
      end

      it "has the sanitized cc address" do
        expect(mail_delivery).to have_cc("cc@sanitize_email.org")
      end

      it "has the sanitized bcc address" do
        expect(mail_delivery).to have_bcc("bcc@sanitize_email.org")
      end

      it "has the original body text" do
        expect(mail_delivery).to have_body_text("Hello. Good Day!")
      end

      it "prepends the original to username" do
        expect(mail_delivery).to have_to_username("vonnegut at example.com")
      end

      it "prepends the original to address to the subject" do
        expect(mail_delivery).to have_subject("(vonnegut at example.com)  Your Roadside Bananas")
      end
    end
  end
end
