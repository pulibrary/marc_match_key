# frozen_string_literal: true

require_relative 'lib/marc_match_key/version'

Gem::Specification.new do |spec|
  spec.name = 'marc_match_key'
  spec.version = MarcMatchKey::VERSION
  spec.authors = ['Mark Zelesky', 'Kevin Reiss', 'Ryan Laddusaw', 'Regine Heberlein', 'Max Kadel',
                  'Christina Chortaria', 'Jane Sandberg']
  spec.email = ['mzelesky@princeton.edu']

  spec.summary = 'A match key for a marc record'
  spec.description = 'A match key for a marc record'
  spec.homepage = 'https://github.com/pulibrary/marc_match_key'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'
  spec.required_rubygems_version = '>= 3.3.11'

  spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/pulibrary/marc_match_key'
  spec.metadata['changelog_uri'] = 'https://github.com/pulibrary/marc_match_key/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'marc', '~> 1.0'
  spec.add_dependency 'nokogiri'

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency 'example-gem', '~> 1.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
