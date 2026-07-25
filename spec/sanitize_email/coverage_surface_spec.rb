# frozen_string_literal: true

require "rails_helper"
require "sanitize_email/test_helpers"
require "sanitize_email/engine_v5"
require "sanitize_email/engine_v6"
require "sanitize_email/railtie"

RSpec.describe "SanitizeEmail coverage surfaces" do
  describe SanitizeEmail::TestHelpers do
    subject(:helper) { Class.new { include SanitizeEmail::TestHelpers }.new }

    it "matches strings and regular expressions" do
      expect(helper.string_matching("hello", "subject", "well hello there")).to be_truthy
      expect(helper.string_matching(/hello/, "subject", "well hello there")).to be_truthy
    end

    it "matches arrays by joining them first" do
      expect(helper.array_matching("two", "to", %w[one two])).to be_truthy
    end

    it "matches attributes from a mail-like object" do
      mail = Struct.new(:subject).new("hello")

      expect(helper.email_matching("hello", :subject, mail)).to be_truthy
    end

    it "raises when matching an unsupported value" do
      expect { helper.string_matching("hello", "subject", Object.new) }
        .to raise_error(SanitizeEmail::TestHelpers::UnexpectedMailType)
    end
  end

  describe SanitizeEmail::RspecMatchers do
    let(:mail) do
      Mail.new do
        from "From Person <from@example.com>"
        to "To Person <to@example.com>"
        cc "Cc Person <cc@example.com>"
        bcc "Bcc Person <bcc@example.com>"
        subject "Subject"
        body "Hello\n  world"
      end
    end

    it "matches object identity via be_* matchers" do
      token = Object.new
      actual = Struct.new(:subject).new(token)

      expect(actual).to be_subject(token)
    end

    it "matches cc and bcc display names" do
      expect(mail).to have_cc_username("Cc Person")
      expect(mail).to have_bcc_username("Bcc Person")
    end

    it "reports missing sanitized headers through matcher helpers" do
      expect(mail).to have_sanitized_cc_header(/no header found/)
    end
  end

  describe "Rails integration shims" do
    it "defines legacy and current Rails integration classes" do
      expect(SanitizeEmail::EngineV5).to be < Rails::Engine
      expect(SanitizeEmail::EngineV6).to be < Rails::Engine
      expect(SanitizeEmail::Railtie).to be < Rails::Railtie
    end
  end
end
