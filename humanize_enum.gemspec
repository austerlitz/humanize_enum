# frozen_string_literal: true

require_relative 'lib/humanize_enum/version'

Gem::Specification.new do |spec|
  spec.name = 'humanize_enum'
  spec.version = HumanizeEnum::VERSION
  spec.authors = ['Max Buslaev']
  spec.email = ['max@buslaev.net']

  spec.summary = 'Enhanced I18n support for ActiveRecord Enums.'
  spec.description = 'Enhanced I18n support for ActiveRecord Enums. Simplifies enums translations and usage in views/serializers.'
  spec.homepage = 'https://github.com/austerlitz/humanize_enum'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split('x0').reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'

end
