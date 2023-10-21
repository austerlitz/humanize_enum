# frozen_string_literal: true

require_relative 'humanize_enum/version'
require_relative 'humanize_enum/enum_translation'
require_relative 'humanize_enum/class_methods'
require 'active_support/lazy_load_hooks'
require 'active_support/inflector'

module HumanizeEnum

  # Error for an unknown enum key
  UnknownEnumKey = Class.new(StandardError)

  # Struct to be used in html selects and similar places
  SelectOption = Struct.new(:id, :value, :text, :checked)

  if defined?(ActiveSupport.on_load)
    ActiveSupport.on_load(:active_record) do
      include HumanizeEnum::EnumTranslation
    end
  end
end
