# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

module SanitizeEmail
  # Provides tools that allow methods to be deprecated with new releases of the gem.
  # See http://www.seejohncode.com/2012/01/09/deprecating-methods-in-ruby/
  module Deprecation
    DEPRECATE_IN_SILENCE_MUTEX = Mutex.new

    class << self
      def deprecate_in_silence
        DEPRECATE_IN_SILENCE_MUTEX.synchronize { @deprecate_in_silence }
      end

      def deprecate_in_silence=(value)
        DEPRECATE_IN_SILENCE_MUTEX.synchronize { @deprecate_in_silence = value }
      end
    end

    @deprecate_in_silence = false

    # Define a deprecated alias for a method
    # @param [Symbol] name - name of method to define
    # @param [Symbol] replacement - name of method to (alias)
    def deprecated_alias(name, replacement)
      # Create a wrapped version
      define_method(name) do |*args, &block|
        warn("SanitizeEmail: ##{name} deprecated (please use ##{replacement})") unless SanitizeEmail::Deprecation.deprecate_in_silence
        send(replacement, *args, &block)
      end
    end

    # Deprecate a defined method
    # @param [Symbol] name - name of deprecated method
    # @param [Symbol] replacement - name of the desired replacement
    def deprecated(name, replacement = nil)
      # Replace old method
      old_name = :"#{name}_without_deprecation"
      alias_method(old_name, name)
      # And replace it with a wrapped version
      define_method(name) do |*args, &block|
        deprecation(name, " (please use ##{replacement})")
        send(old_name, *args, &block)
      end
    end

    def deprecation(name, replacement = nil)
      if replacement
        deprecation_warning_message("SanitizeEmail: ##{name} deprecated#{replacement}")
      else
        deprecation_warning_message("SanitizeEmail: ##{name} deprecated")
      end
    end

    def deprecation_warning_message(message)
      warn(message) unless SanitizeEmail::Deprecation.deprecate_in_silence
    end
  end
end
