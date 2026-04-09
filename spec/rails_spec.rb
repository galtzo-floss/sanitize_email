RSpec.describe Rails do
  expected_rails_version = ENV.fetch("RAILS_MAJOR_MINOR", nil)
  actual_rails_version = "#{described_class::VERSION::MAJOR}.#{described_class::VERSION::MINOR}"
  if expected_rails_version.nil?
    it "has Rails Version (default, 7.2) matching actual #{actual_rails_version}" do
      # When not otherwise set, Rails should be 7.2
      expect(actual_rails_version).to match("7.2")
    end
  else
    it "has Rails Version (custom from ENV, #{expected_rails_version}) matching actual #{actual_rails_version}" do
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

      it "sends email" do
        expect(mail_delivery).to have_from("roadside-bananas@example.com")
        expect(mail_delivery).to have_reply_to("jingle-berry@example.com")
        expect(mail_delivery).to have_to("vonnegut@example.com")
        expect(mail_delivery).to have_cc("charlie@example.org")
        expect(mail_delivery).to have_bcc("candy-mountain@example.org")
        expect(mail_delivery).to have_body_text("Hello. Good Day!")
        expect(mail_delivery).not_to have_to_username("vonnegut")
        expect(mail_delivery).to have_subject("Your Roadside Bananas")
      end

      context "when sanitary" do
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

        it "sends email" do
          expect(mail_delivery).to have_from("roadside-bananas@example.com")
          expect(mail_delivery).to have_reply_to("jingle-berry@example.com")
          expect(mail_delivery).to have_to("to@sanitize_email.org")
          expect(mail_delivery).to have_cc("cc@sanitize_email.org")
          expect(mail_delivery).to have_bcc("bcc@sanitize_email.org")
          expect(mail_delivery).to have_body_text("Hello. Good Day!")
          expect(mail_delivery).to have_to_username("vonnegut at example.com")
          expect(mail_delivery).to have_subject("(vonnegut at example.com)  Your Roadside Bananas")
        end
      end
    end
  end
end
