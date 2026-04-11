# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

module SanitizeEmail
  # Tools for modifying the header of an email
  module MailHeaderTools
    class << self
      def prepend_subject_array(message)
        prepend = []
        if SanitizeEmail.use_actual_email_prepended_to_subject
          prepend << SanitizeEmail::MailHeaderTools
            .prepend_email_to_subject(Array(message.to))
        end
        if SanitizeEmail.use_actual_environment_prepended_to_subject
          prepend << SanitizeEmail::MailHeaderTools
            .prepend_environment_to_subject
        end
        # this will force later joins to add an extra space
        prepend << "" unless prepend.empty?
        prepend
      end

      def custom_subject(message)
        prepend_subject_array(message).join(" ")
      end

      def prepend_environment_to_subject
        if SanitizeEmail::Config.config[:environment].respond_to?(:call)
          SanitizeEmail::Config.config[:environment].call.to_s
        else
          SanitizeEmail::Config.config[:environment].to_s
        end
      end

      def prepend_email_to_subject(actual_addresses)
        "(#{Array(actual_addresses).uniq.join(",").gsub(/@/, " at ")
          .gsub(/[<>]/, "~")})"
      end

      def add_original_addresses_as_headers(message)
        # Add headers by string concat.
        # Setting hash values on message.headers does nothing, strangely.
        # See: http://goo.gl/v46GY
        to_addrs = message[:to]&.addrs
        cc_addrs = message[:cc]&.addrs
        to_decoded = Array(to_addrs&.map(&:decoded))
        cc_decoded = Array(cc_addrs&.map(&:decoded))
        {
          # can be an arrays, so casting it as arrays
          "X-Sanitize-Email-To" => to_decoded,
          "X-Sanitize-Email-Cc" => cc_decoded,
          # Don't write out the BCC, as those addresses should not be visible
          #   in message headers for obvious reasons
        }.each do |header_key, header_value|
          # For each type of address line
          SanitizeEmail::MailHeaderTools.update_header(
            header_key,
            header_value,
            message,
          )
        end
      end

      def prepend_custom_subject(message)
        message.subject = "" unless message.subject
        custom_subject = SanitizeEmail::MailHeaderTools.custom_subject(message)
        message.subject = custom_subject + message.subject
      end

      # According to https://github.com/mikel/mail
      #   this is the correct way to update headers.
      def update_header(header_key, header_value, message)
        return unless header_value

        # For each address, as header_value can be an array of addresses
        Array(header_value).each_with_index do |elem, index|
          num = index + 1
          new_header_key = (num > 1) ? "#{header_key}-#{num}" : header_key
          message.header[new_header_key] = elem.to_s
        end
      end
    end
  end
end
