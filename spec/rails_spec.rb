require "rails_helper"

RSpec.describe Rails do
  let(:expected_rails_version) { ENV.fetch("RAILS_MAJOR_MINOR", nil) }
  let(:actual_rails_version) { "#{described_class::VERSION::MAJOR}.#{described_class::VERSION::MINOR}" }

  before do
    sanitize_spec_dryer
  end

  env_rails_version = ENV.fetch("RAILS_MAJOR_MINOR", nil)
  desc_rails_version = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
  bundle_gemfile = ENV.fetch("BUNDLE_GEMFILE", "")
  appraisal_gemfile = bundle_gemfile.include?("/gemfiles/ruby_")
  if env_rails_version && appraisal_gemfile
    it "has Rails Version (custom from ENV, #{env_rails_version}) matching actual #{desc_rails_version}" do
      expect(actual_rails_version).to eq(expected_rails_version)
    end
  else
    # Assert against the Rails fragment (gemfiles/rails_X_Y.gemfile) that the loaded Gemfile
    # actually evals, e.g. the main Gemfile (8.0) vs. the "current" appraisal (7.2).
    loaded_gemfile = bundle_gemfile.empty? ? File.expand_path("../Gemfile", __dir__) : bundle_gemfile
    fragment = File.file?(loaded_gemfile) ? File.read(loaded_gemfile).scan(/rails_(\d+)_(\d+)\.gemfile/).last : nil
    if fragment
      declared = fragment.join(".")
      it "has Rails Version (declared by #{File.basename(loaded_gemfile)}, #{declared}) matching actual #{desc_rails_version}" do
        expect(actual_rails_version).to eq(declared)
      end
    else
      it "has a Rails Version (#{desc_rails_version}) when the loaded gemfile declares no rails_X_Y fragment" do
        expect(actual_rails_version).to match(/\A\d+\.\d+\z/)
      end
    end
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
