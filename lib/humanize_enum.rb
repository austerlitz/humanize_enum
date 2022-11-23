# frozen_string_literal: true

require_relative 'humanize_enum/version'
require_relative 'humanize_enum/helpers'
require 'active_support/lazy_load_hooks'

module HumanizeEnum
  if defined?(ActiveSupport.on_load)
    ActiveSupport.on_load(:active_record) do
      include HumanizeEnum::Helpers
    end
  end
end
