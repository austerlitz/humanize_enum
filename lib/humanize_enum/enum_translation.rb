module HumanizeEnum
  module EnumTranslation

    def self.included(base)
      base.extend HumanizeEnum::ClassMethods
    end

    # @return [String] translated enum value of an instance
    # @example
    #   payment = Payment.new
    #   payment.status = 'initial'
    #   payment.humanize_enum(:status) # => 'Initial'
    def humanize_enum(enum_name)
      self.class.check_enum!(enum_name)
      I18n.t("activerecord.attributes.#{self.class.model_name.i18n_key}.#{enum_name}/#{send(enum_name).to_s.underscore}")
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
