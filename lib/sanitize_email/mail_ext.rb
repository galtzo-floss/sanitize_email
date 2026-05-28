# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license
require "mail"

# Cribbed from email_spec gem
module SanitizeEmail
  module MailExt
    def default_part
      @default_part ||= html_part || text_part || self
    end

    def default_part_body
      default_part.body
    end
  end
end

Mail::Message.send(:include, SanitizeEmail::MailExt)
