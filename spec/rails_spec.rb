RSpec.describe Rails do
  let(:expected_rails_version) { ENV.fetch("RAILS_MAJOR_MINOR", nil) }
  let(:actual_rails_version) { "#{described_class::VERSION::MAJOR}.#{described_class::VERSION::MINOR}" }

  env_rails_version = ENV.fetch("RAILS_MAJOR_MINOR", nil)
  desc_rails_version = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
  if env_rails_version.nil?
    it "has Rails Version (default, 7.2) matching actual #{desc_rails_version}" do
      # When not otherwise set, Rails should be 7.2
      expect(actual_rails_version).to match("7.2")
    end
  else
    it "has Rails Version (custom from ENV, #{env_rails_version}) matching actual #{desc_rails_version}" do
      expect(actual_rails_version).to eq(expected_rails_version)
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
            use_actual_email_as_sanitized_user_name: true,
          },
          false,
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
