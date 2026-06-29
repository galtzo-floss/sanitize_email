# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

# External Libraries
require "mail"

module SanitizeEmail
  # Tools for overriding addresses
  class OverriddenAddresses
    # Raised when there are no recipients after sanitization
    class MissingRecipients < StandardError; end

    # MissingTo is Deprecated
    class MissingTo < MissingRecipients; end

    # Raised if there is a recipient type that sanitize_email doesn't recognize.
    # If you get this error please report it.
    # recognized recipient types are: TO, CC, and BCC
    class UnknownOverride < StandardError; end

    REPLACE_AT = [/@/, " at "].freeze
    REPLACE_ALLIGATOR = [/[<>]/, "~"].freeze
    attr_accessor :tempmail,
      :overridden_to,
      :overridden_cc,
      :overridden_bcc,
      :overridden_personalizations,
      :good_list, # Allow-listed addresses will not be molested as to, cc, or bcc
      :bad_list, # Block-listed addresses will be removed from to, cc and bcc when sanitization is engaged
      :sanitized_to,
      :sanitized_cc,
      :sanitized_bcc # Replace non-allow-listed addresses with these sanitized addresses.

    def initialize(message, **args)
      # Not using extract_options! because non-rails compatibility is a goal
      args = SanitizeEmail::Config.to_init.merge(args)
      @sanitized_to = args[:sanitized_to]
      @sanitized_cc = args[:sanitized_cc]
      @sanitized_bcc = args[:sanitized_bcc]
      @good_list = args[:good_list] || []
      @bad_list = args[:bad_list] || []
      # Mail will do the username parsing for us.
      @tempmail = Mail.new

      tempmail.to = to_override(message.to)
      tempmail.cc = cc_override(message.cc)
      tempmail.bcc = bcc_override(message.bcc)

      # remove addresses from :cc / :bcc that are also in :to
      remove_duplicates

      @overridden_to = tempmail[:to].decoded
      @overridden_cc = tempmail[:cc].decoded
      @overridden_bcc = tempmail[:bcc].decoded

      actual_personalizations = message["personalizations"]
      if actual_personalizations.nil?
        raise MissingRecipients, "No recipients left post-sanitization" if (tempmail.to + tempmail.cc + tempmail.bcc).empty?
      elsif actual_personalizations.respond_to?(:unparsed_value)
        @overridden_personalizations = personalizations_override(actual_personalizations)
      else
        # TODO: Remove check when dropping Rails 3.x
        #       undefined method `unparsed_value' for #<Mail::OptionalField>
        raise MissingRecipients, "Mail version is too old to use personalizations"
      end
    end

    # Allow good listed email addresses, and then remove the bad listed addresses
    def good_listize(real_addresses)
      good_listed = clean_addresses(real_addresses, :good_list)
      good_listed = clean_addresses(good_listed, :bad_list) unless good_listed.empty?
      good_listed
    end

    def to_override(actual_addresses)
      to = override_email(:to, actual_addresses)
      to.join(",")
    end

    def cc_override(actual_addresses)
      override_email(:cc, actual_addresses).join(",")
    end

    def bcc_override(actual_addresses)
      override_email(:bcc, actual_addresses).join(",")
    end

    # Intended to result in compatibility with https://github.com/eddiezane/sendgrid-actionmailer
    def personalizations_override(actual_personalizations)
      actual_personalizations.unparsed_value.map do |actual_personalization|
        actual_personalization.merge(
          to: actual_personalization[:to]&.map do |to|
            to.merge(email: override_email(:to, to[:email]).join(","))
          end,
          cc: actual_personalization[:cc]&.map do |cc|
            cc.merge(email: override_email(:cc, cc[:email]).join(","))
          end,
          bcc: actual_personalization[:bcc]&.map do |bcc|
            bcc.merge(email: override_email(:bcc, bcc[:email]).join(","))
          end
        )
      end
    end

    def override_email(type, actual_addresses)
      # Normalized to an arrays
      # puts "override_email 1: #{type} - #{actual_addresses}"
      real_addresses = Array(actual_addresses)

      # puts "override_email 2: #{type} - #{real_addresses}"
      # If there were no original recipients, then we DO NOT override the nil with the sanitized recipients
      return [] if real_addresses.empty?

      good_listed = good_listize(real_addresses)
      # puts "override_email 3: #{type} - #{good_listed}"
      # If there are good_list addresses to send to then use them as is, no mods needed
      return good_listed unless good_listed.empty?

      # TODO: Allow overriding if an addressed email is on the good list?
      # If there are no sanitized addresses we can't override!
      sanitized_addresses = sanitize_addresses(type)
      # puts "override_email 4: #{type} - #{sanitized_addresses}"
      return [] if sanitized_addresses.empty?

      # At this point it is assured that the address list will need to be sanitized
      # One more check to ensure none of the configured sanitized email addresses are on the bad_list
      sanitized_addresses = clean_addresses(sanitized_addresses, :bad_list)
      # puts "override_email 5: #{type} - #{sanitized_addresses}"

      # If we don't want to inject the "email" in the "user name" section of the sanitized recipients,
      # then just return the default sanitized recipients
      return sanitized_addresses unless SanitizeEmail.use_actual_email_as_sanitized_user_name

      inject_user_names(real_addresses, sanitized_addresses)
      # puts "real_addresses 2: #{real_addresses}"
      # puts "override_email 6: #{type} - #{with_user_names}"
      # Otherwise inject the email as the "user name"
    end

    def address_list_filter(list_type, address)
      # TODO: How does this handle email addresses with user names like "Foo Example <foo@example.org>"
      has_address = send(list_type).include?(address)
      case list_type
      when :good_list
        has_address ? address : nil
      when :bad_list
        has_address ? nil : address
      else
        raise ArgumentError, "address_list_filter got unknown list_type: #{list_type}"
      end
    end

    def inject_user_names(real_addresses, sanitized_addresses)
      real_addresses.each_with_object([]) do |real_recipient, result|
        new_recipient = if real_recipient.nil?
          sanitized_addresses
        else
          # puts "SANITIZED: #{sanitized_addresses}"
          sanitized_addresses.map { |sanitized| "#{real_recipient.gsub(REPLACE_AT[0], REPLACE_AT[1]).gsub(/[<>]/, "~")} <#{sanitized}>" }
        end
        result << new_recipient
      end.flatten
    end

    def clean_addresses(addresses, list_type)
      # Normalize addresses just in case it isn't an array yet
      addresses.map do |address|
        # If this address is on the good list then let it pass
        address_list_filter(list_type, address)
      end.compact.uniq
    end

    def sanitize_addresses(type)
      case type
      when :to
        Array(sanitized_to)
      when :cc
        Array(sanitized_cc)
      when :bcc
        Array(sanitized_bcc)
      else
        raise UnknownOverride, "unknown email override"
      end
    end

    private

    def remove_duplicates
      dedup_addresses = tempmail[:to].addresses

      tempmail[:cc].addrs.reject! do |addr|
        # If this email address is already in the :to list, then remove
        dedup_addresses.include?(addr.address)
      end
      dedup_addresses += tempmail[:cc].addresses
      tempmail[:bcc].addrs.reject! do |addr|
        # If this email address is already in the :to list, then remove
        dedup_addresses.include?(addr.address)
      end
    end
  end
end
