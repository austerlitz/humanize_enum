module HumanizeEnum
  module Helpers
    def self.included(base)
      base.extend ClassMethods
    end

    # Struct to be used in html selects and similar places
    SelectOption = Struct.new(:id, :value, :text, :checked)

    module ClassMethods
      # @return [String] translated value of an enum
      # @example
      #   Payment.humanize_enum(:status, :pending) # => 'Pending'
      def humanize_enum(enum_name, enum_value)
        I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name}/#{enum_value}")
      end

      # @return [Hash<String, String>] hash where key is enum name and value is its translation
      # @example
      #   Payment.humanize_enums(:status)
      #   {
      #     initial: 'Initial status',
      #     paid:    'Payment processed',
      #     error:   'Payment error'
      #   }
      def humanize_enums(enum_name)
        enum_options(enum_name).map do |enum|
          [enum.value, enum.text]
        end.to_h
      end

      # @return [Array<SelectOption>] array of structs with :id, :key, :text, :checked
      def enum_options(enum_name)
        enum_i18n_key = enum_name.to_s.pluralize
        send(enum_i18n_key).map do |key, val|
          SelectOption.new(val, key, humanize_enum(enum_name, key), nil)
        end
      end
    end

    # @return [String] translated enum value of an instance
    # @example
    #   payment = Payment.new
    #   payment.status = 'initial'
    #   payment.humanize_enum(:status) # => 'Initial'
    def humanize_enum(enum_name)
      I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name}/#{self[enum_name]}")
    end

    # @see .humanize_enums
    def humanize_enums(enum_name)
      self.class.humanize_enums(enum_name)
    end

    # @return [Array<SelectOption>]
    # @see .enum_options
    def enum_options(enum_name)
      self.class.enum_options(enum_name)
    end
  end
end
